# **Armageddon Lab 1a **

## **Purpose**

This runbook deploys an EC2 instance and an RDS MySQL database using AWS Secrets Manager to store and retrieve credentials. This is a basic workflow that covers security group, private databases, IAM least-privilege access, and basic web app validation.

---

## **Prerequisites**

- Recommended: Working **3-tier VPC** (best practice)
  - Public subnet(s) for EC2
  - Private subnet(s) with access to NAT (not used for this lab)
  - Private subnet(s) for RDS

---

## **Stage 1: Security Group Configuration**

### **Step 1.1: Create EC2 Security Group (`ec2-lab-sg`)**

Inbound Rules:
- Type: HTTP, Protocol: TCP, Port: 80, Source: All (0.0.0.0/0)
- Type: SSH, Protocol: TCP, Port: 22, Source: Trusted IPv4 address (`My IP` in console)


Outbound Rules:
- Leave default (Allow all)

<img src="./images/ec2_lab_sg.png" alt="EC2 Lab Security Group" width="90%">

---

### **Step 1.2: Create RDS Security Group (`private-db-sg`)**

Inbound Rules:
- Type: MySQL/Aurora, Protocol: TCP, Port: 3306, Source: **Security Group reference** → `ec2-lab-sg`

Outbound Rules:
- Leave default (Allow all)

<img src="./images/private_db_sg.png" alt="Private DB Security Group" width="90%">

---

## **Stage 2: RDS Subnet Group**

### **Step 2.1: Create DB Subnet Group**

Navigate to **RDS → Subnet Groups → Create DB Subnet Group**

Subnet Group Details:
- Name: `armageddon-rds-subnet-group`
- Description: RDS subnet group
- VPC: Select your target VPC

Subnets:
- Select **at least two private subnets**. This this lab only uses a single-AZ, but multi AZ is scalable and a good practice.
- These should be your fully private / data-tier subnets

<img src="./images/subnet_group.png" alt="RDS Subnet Group" width="90%">

---

## **Stage 3: RDS MySQL Database Creation**

### **Step 3.1: Database Configuration**

- Creation method: **Standard (Full configuration)**
- Engine type: MySQL
- Engine version: Default (MySQL 8.0.43)
- Template: Sandbox
- Availability: Single-AZ DB instance

<img src="./images/create_database_1.png" alt="Create Database Step 1" width="90%">

<br>

<img src="./images/create_database_2.png" alt="Create Database Step 2" width="90%">

---

### **Step 3.2: Settings**

- DB instance identifier: `lab-mysql`
- Master username: `admin`
- Credential management: Self-managed
  - Master password:
    - Generate a strong password
    - Store in a secure password vault

> **Important:** For the database credentials, **Self Managed** is simpler and more reliable.  
> Choosing "Managed in AWS Secrets Manager" enables automatic password rotation, but it **requires advanced setup** to work (Lambda function, VPC networking, security group rules, etc).
> If not properly ocnfigured, the database password won't be synced and will cause connection errors.

<br>

<img src="./images/create_database_3.png" alt="Create Database Step 3" width="90%">

---

### **Step 3.3: Instance Configuration**

- Instance class: Burstable (`db.t4g.micro` or `db.t3.micro`)
- Storage: Defaults

---

### **Step 3.4: Connectivity**

- Compute resource: Do **not** connect to EC2
- VPC: Same VPC as EC2
- DB subnet group: `armageddon-rds-subnet-group`
- Public access: **No**
- Security groups:
  - Remove default
  - Attach `private-db-sg`
- Leave remaining settings default
- Click **Create database**

<img src="./images/connectivity.png" alt="RDS Connectivity Settings" width="90%">

---

## **Stage 4: Secrets Manager Configuration**

### **Step 4.1: Store Database Credentials**

Navigate to **Secrets Manager → Store a new secret**

- Secret type: Credentials for Amazon RDS database
- Username: `admin`
- Password: Same password you used for RDS
- Encryption key: Default
- Database: Select `lab-mysql`

<img src="./images/create_secret_1.png" alt="Create Secret Step 1" width="90%">

---

### **Step 4.2: Configure Secret**

- Secret name: `lab/rds/mysql`
- Description: DB credentials for lab-mysql
- Store the secret
- Record the **Secret Name and ARN**

<img src="./images/create_secret_2.png" alt="Create Secret Step 2" width="90%">

---

## **Stage 5: IAM Policy and Role**

### **Step 5.1: Create IAM Policy**

IAM → Policies → Create Policy → JSON editor

<img src="./images/policy_editor.png" alt="IAM Policy JSON Editor" width="90%">

- Copy and paste [Theo's inline policy](1a_inline_policy.json) into the JSON editor:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ReadSpecificSecret",
      "Effect": "Allow",
      "Action": ["secretsmanager:GetSecretValue"],
      "Resource": "arn:aws:secretsmanager:<REGION>:<ACCOUNT_ID>:secret:lab/rds/mysql*"
    }
  ]
}
```

- Replace `<REGION>` and `<ACCOUNT_ID>` using values from your secret ARN.
- Policy name: `read-specific-secret`

<img src="./images/create_policy.png" alt="Create Policy Step 2" width="90%">

---

### **Step 5.2: Create IAM Role**

IAM → Roles → Create Role

- Trusted entity: AWS Service
- Use case: EC2 (JSON code is auto generated in the next step)
- Attach policy: `read-specific-secret`
- Role name: `ec2-get-db-secret-lab-1a`
- Description: Allows EC2 instances to retrieve RDS secret

<img src="./images/select_trusted_entity.png" alt="Select Trusted Entity" width="90%">

<br>

<img src="./images/role_details.png" alt="IAM Role Details" width="90%">

## **Stage 6: Modify EC2 User Data Script**

### **Step 6.1: Local Preparation**

- Navigate to your preferred working directory
- Create a new file named `updated_script`
- Open the file in VS Code

<img src="./images/make_script_file.png" alt="Create User Data Script File" width="90%">

- Copy [Theo's user data script](1a_user_data.sh)
- Update region value to match your VPC region (e.g. `us-west-2`)
- Save the file

<img src="./images/vs_code_region.png" alt="VS Code Region Update" width="90%">

### **Step 6.2: User Data Script (Modified for us-west-2) **

``` shell
#!/bin/bash
dnf update -y
dnf install -y python3-pip
pip3 install flask pymysql boto3

mkdir -p /opt/rdsapp
cat >/opt/rdsapp/app.py <<'PY'
import json
import os
import boto3
import pymysql
from flask import Flask, request

REGION = os.environ.get("AWS_REGION", "us-west-2")
SECRET_ID = os.environ.get("SECRET_ID", "lab/rds/mysql")

secrets = boto3.client("secretsmanager", region_name=REGION)

def get_db_creds():
    resp = secrets.get_secret_value(SecretId=SECRET_ID)
    s = json.loads(resp["SecretString"])
    # When you use "Credentials for RDS database", AWS usually stores:
    # username, password, host, port, dbname (sometimes)
    return s

def get_conn():
    c = get_db_creds()
    host = c["host"]
    user = c["username"]
    password = c["password"]
    port = int(c.get("port", 3306))
    db = c.get("dbname", "labdb")  # we'll create this if it doesn't exist
    return pymysql.connect(host=host, user=user, password=password, port=port, database=db, autocommit=True)

app = Flask(__name__)

@app.route("/")
def home():
    return """
    <h2>EC2 → RDS Notes App</h2>
    <p>POST /add?note=hello</p>
    <p>GET /list</p>
    """

@app.route("/init")
def init_db():
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
    return "Initialized labdb + notes table."

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
    app.run(host="0.0.0.0", port=80)
PY

cat >/etc/systemd/system/rdsapp.service <<'SERVICE'
[Unit]
Description=EC2 to RDS Notes App
After=network.target

[Service]
WorkingDirectory=/opt/rdsapp
Environment=SECRET_ID=lab/rds/mysql
ExecStart=/usr/bin/python3 /opt/rdsapp/app.py
Restart=always

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable rdsapp
systemctl start rdsapp
```

## **Stage 7: Launch EC2 Instance**

### **Step 7.1: EC2 Configuration**

- AMI: Amazon Linux 2023
- Instance type: `t2.micro` (or similar)
- Key pair: Create new, download `.pem`
- Network:
    - VPC: Same VPC as RDS
    - Subnet: Public subnet
- Security group: `ec2-lab-sg`

<img src="./images/ec2_setup_1.png" alt="EC2 Setup Configuration" width="90%">

---

### **Step 7.2: Advanced Details**

- IAM Instance Profile: `ec2-get-db-secret-lab-1a`
- User data: Paste **updated_script.sh**
- Launch the instance

<img src="./images/attach_iam_role.png" alt="Attach IAM Role to EC2" width="90%">

---

## **Stage 8: SSH Key Permissions**

- While the EC2 is launching, configure your key file (for testing via SSH later, if desired)

```bash
cd <key-directory>`
```

```bash
ls chmod 600 <key.pem>
```

```bash
ls -l
```

- **Expected result:** Read/write permissions for owner only.

<img src="./images/confirm_key_permissions.png" alt="Confirm SSH Key Permissions" width="90%">

---

## **Stage 9: Application Testing**

### **Step 9.1: Verify the Application Loads**

- Copy the EC2's public DNS
- Open in a browser and confirm the app loads

<img src="./images/public_app_loaded.png" alt="Public Application Loaded" width="90%">

**Troubleshooting**:
- If your app doesn’t load, double check your security groups to make sure public HTTP traffic is allowed.
- Once you confirm you have HTTP access to your EC2 instance and the app loads successfully, move on to the next step.


---

### **Step 9.2: Initialize Database**

`http://<EC2_PUBLIC_IP>/init`

- Copy your EC2's public IP address
- Modify the link and paste it in your browser

Expected results:

<img src="./images/init_success.png" alt="Database Initialization Success" width="90%">

**A note from Theo:**
>“If `/init` hangs or errors, it’s almost always due to one of the following: the RDS SG doesn't allow inbound traffic on port 3306 from the EC2 security group; the RDS instance is not in the same VPC or subnets not routed properly; the EC2 role is missing `secretsmanager:GetSecretValue`; or the secret doesn't contain the `host`, `username`, and `password` fields.”

**Troubleshooting:**

- If you receive an error, check the following, then test `/init` again:
	- RDS SG allows inbound 3306 from EC2 SG
	- EC2 and RDS are in same VPC
	- Subnets properly routed in VPC
	- IAM policy is properly configured with correct permissions
	- IAM role has the policy attached and is assigned to the EC2 instance
	- Secret contains `host`, `username`, `password`
	- Make sure the IAM role is functioning correctly.
		- SSH into EC2 instance from key file directory: 
			- `ssh -i <key.pem> ec2-user@<EC2-PUBLIC-IP>
		- Show Role Information:
			-  `aws sts get-caller-identity`
		- Retrieve the secret value manually:
			- `aws secretsmanager get-secret-value --secret-id lab/rds/mysql`

A correctly functioning IAM Role can retrieve the secret manually:

<img src="./images/iam_role_troubleshoot.png" alt="IAM Role Troubleshooting" width="90%">

If your IAM Role is functioning properly, but the database isn't initializing, move on to the next step for additional troubleshooting.


#### **Step 9.2a: Additional Troubleshooting

Define the region and default region to run the rdsapp service by adding this to the service block in the EC2  script (line 105, where the environment is defined)

```bash
Environment=AWS_REGION=us-west-2
Environment=AWS_DEFAULT_REGION=us-west-2
```

<img src="./images/updated_script_2.png" alt="Updated User Data Script" width="90%">

Launch a new instance with the updated script may solve the issue by forcing the service to recognize the correct region.

---

### **Step 9.3: Write Notes**

Paste this link in your browser to post the first note.

`http://<EC2_PUBLIC_IP>/add?note=hello`

**Expected results:**

<img src="./images/add_note_success.png" alt="Add Note Success" width="90%">

- Afterwards, modify `note` value to add more entries.
- Post at least 3 notes.

**Troubleshooting:**
- Correct any spelling errors or missing note values to avoid errors like these:

<img src="./images/add_note_error_1.png" alt="Add Note Error 1" width="90%">

<br>

<img src="./images/add_note_error_2.png" alt="Add Note Error 2" width="90%">


---

### **Step 9.4: Read Notes**

Paste this link in your browser to view a list of the notes.

`http://<EC2_PUBLIC_IP>/list`

Expected result:

<img src="./images/list_notes.png" alt="List Notes Output" width="90%">
