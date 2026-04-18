#!/bin/bash

set -euo pipefail

mkdir -p /opt/aws/amazon-cloudwatch-agent/logs
mkdir -p /opt/rdsapp

# Write application code to Python file
cat >/opt/rdsapp/app.py <<'PY'
import json
import os
import time
import boto3
import pymysql
from flask import Flask, request

REGION = os.environ.get("AWS_REGION", "us-east-1")
SECRET_ID = os.environ.get("SECRET_ID", "lab/rds/mysql")

secrets = boto3.client("secretsmanager", region_name=REGION)

def get_db_creds():
    resp = secrets.get_secret_value(SecretId=SECRET_ID)
    s = json.loads(resp["SecretString"])
    return s

# Verify DB server is reachable before init
def check_db_connection():
    c = get_db_creds()
    conn = pymysql.connect(
        host=c["host"],
        user=c["username"],
        password=c["password"],
        port=int(c.get("port", 3306)),
        connect_timeout=5
    )
    conn.close()

def get_conn():
    c = get_db_creds()
    host = c["host"]
    user = c["username"]
    password = c["password"]
    port = int(c.get("port", 3306))
    db = c.get("dbname", "labdb")  # we'll create this if it doesn't exist
    return pymysql.connect(host=host, user=user, password=password, port=port, database=db, autocommit=True)

# Database initialization logic (decoupled from /init route)
# Can be invoked at startup 
def init_db(context="APP_INIT"):
    c = get_db_creds()
    host = c["host"]
    user = c["username"]
    password = c["password"]
    port = int(c.get("port", 3306))

    # connect without specifying a DB first
    conn = pymysql.connect(host=host, user=user, password=password, port=port, autocommit=True)
    cur = conn.cursor()
    cur.execute("CREATE DATABASE IF NOT EXISTS labdb;")
    cur.execute("USE labdb;")
    cur.execute("""
        CREATE TABLE IF NOT EXISTS notes (
            id INT AUTO_INCREMENT PRIMARY KEY,
            note VARCHAR(255) NOT NULL
        );
    """)
    cur.close()
    conn.close()
    print(f"[{context}] [DB] Database and notes table successfully initialized.")
    return "[HTTP/HTTPS] [MANUAL_INIT] Initialized labdb + notes table."


def wait_for_db(max_attempts=24, delay=5):
    # Waits for database to accept connections and retries if needed.
    # Total wait time = max_attempts * delay (seconds).

    wait_time = max_attempts * delay

    for attempt in range(1, max_attempts + 1):
        try:
            check_db_connection()
            print(f"[LIFECYCLE][DB_WAIT] DB reachable on attempt {attempt}.")
            return
        except Exception as e:
            print(f"[LIFECYCLE][DB_WAIT] Attempt {attempt}/{max_attempts} failed: {e}")
            time.sleep(delay)

    raise TimeoutError(
        f"[LIFECYCLE][DB_WAIT][TIMEOUT] "
        f"Database not reachable after {max_attempts} attempts "
        f"({wait_time}s total)."
    )

app = Flask(__name__)

@app.route("/")
def home():
    return """
    <h2>EC2 → RDS Notes App</h2>
    <p>POST /add?note=hello</p>
    <p>GET /list</p>
    """

# HTTP route for manual DB initialization (dev/test).
@app.route("/init")
def init_route():
    return init_db(context="MANUAL_INIT")


@app.route("/add", methods=["POST", "GET"])
def add_note():
    note = request.args.get("note", "").strip()
    if not note:
        return "Missing note param. Try: /add?note=hello", 400
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("INSERT INTO notes(note) VALUES(%s);", (note,))
    cur.close()
    conn.close()
    return f"Inserted note: {note}"

@app.route("/list")
def list_notes():
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("SELECT id, note FROM notes ORDER BY id DESC;")
    rows = cur.fetchall()
    cur.close()
    conn.close()
    out = "<h3>Notes</h3><ul>"
    for r in rows:
        out += f"<li>{r[0]}: {r[1]}</li>"
    out += "</ul>"
    return out

if __name__ == "__main__":
    wait_for_db()
    init_db(context="LIFECYCLE")
    app.run(host="0.0.0.0", port=80)
PY

# Write environment file on the EC2 instance
cat >/etc/sysconfig/rdsapp <<EOF
AWS_REGION=${region}
SECRET_ID=${secret_id}
EOF

# Create systemd service unit
cat >/etc/systemd/system/rdsapp.service <<'SERVICE'
[Unit]
Description=EC2 to RDS Notes App
After=network.target

[Service]
WorkingDirectory=/opt/rdsapp
EnvironmentFile=/etc/sysconfig/rdsapp
ExecStart=/usr/bin/python3 /opt/rdsapp/app.py

Restart=always

[Install]
WantedBy=multi-user.target
SERVICE

# Sleep so dependencies initialize
echo "[INFO] Sleeping 60s to give VPC endpoints and dependencies time to initialize" >> /var/log/user_data.log
sleep 60

# Start RDS App
echo "[INFO] Starting RDSApp service" >> /var/log/user_data.log
systemctl enable rdsapp
systemctl start rdsapp

# Fetch Config and start CloudWatch Agent
echo "[INFO] Fetching and starting CloudWatch Agent" >> /var/log/user_data.log
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c ssm:/rds-app/cloudwatch-agent/config-${name_suffix} \
  -s

# Persist CloudWatch Agent across reboot / ASG replacement
systemctl enable amazon-cloudwatch-agent