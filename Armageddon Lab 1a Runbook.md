### Project Overview (What You Are Building):
In this lab, you will build a classic cloud application architecture: A compute layer running on an Amazon EC2 instance, a managed relational database hosted on Amazon RDS Secure connectivity between the two using VPC networking and security groups, credential management using AWS Secrets Manager, and a simple application that writes and reads data from the database

This lab will build working knowledge on :
- How EC2 communicates with RDS 
- How database access is restricted 
- Where credentials are stored 
- How connectivity is validated 
- How failures are debugged

ARCHITECTURAL DESIGN LOGICAL FLOW
1. user sends an HTTP request to the EC2 instance
2. The EC2 app retrieves database credentials from Secrets Manager Connects to the RDS MySQL endpoint
3. Data is written to and read from the database
4. Results of the query are returned to the user

REQUIREMENTS
1. RDS cannot be publicly accessible
2. RDS only allows inbound traffic from the EC2 security group
3. EC2 retrieves credentials via the IAM role
4. No passwords are stored in code or in the AMIs
#### Step 1 : Create your VPC
- Create subnet that you will allocate to the RDS (3-tier VPC)
- Resources to create : VPC and more
- Name tag auto-generation : irish-armageddon
- IPv4 CIDR block : 10.13.0.0/16 (select your CIDR block)
- Tenancy : default
- Number of AZs : 3 (appropriate for the eu-west-1 region selected)
- Customize subnets CIDR blocks
	- Number of private subnets : 6 (enough for the purpose of this lab)
	- Customize subnets CIDR blocks > select the public and private CIDR block subnet nomenclature that you deem appropriate
Private subnet C : 10.13.13.0/24
		- Public subnet B : 10.13.2.0/24
		- Public subnet C : 10.13.3.0/24
		- Private subnet A : 10.13.11.0/24
		- Private subnet B : 10.13.12.0/24
		- Private subnet C : 10.13.13.0/24
		- Private subnet D : 10.13.111.0/24
		- Private subnet E : 10.13.112.0/24
		- Private subnet F : 10.13.113.0/24
- Create VPC

````sh
aws ec2 describe-vpcs --region eu-west-1
````

- For general best-practice, make sure to configure a 3-tier VPC which has presentation layer, application layer, and data layer
#### Step 2: Create security groups
- Create security group for EC2 (ec2-lab-sg)
	- inbound rules : HTTP TCP 80 from 0.0.0.0/0
	- inbound : SSH TCP 22 from My IP only
	- outbound : default (allow-all)
- Create security group for RDS (rds-lab-sg)
	- inbound MySQL TCP 3306 = ec2-lab-sg
	- outbound : default (allow all)
##### Run the following checks to verify your security groups' rules (#CRITICAL)

Verify the EC2 security group rules
````sh
aws ec2 describe-security-groups  
--group-names ec2-rds-lab  
--query "SecurityGroups[].IpPermissions"
````
Expected: TCP port 80 source referencing 0.0.0.0/0 (anywhere IPv4) / TCP port 22 source referencing My IP only

Verify the RDS security group rules
````sh
aws ec2 describe-security-groups  
--group-names rds-lab-sg  
--query "SecurityGroups[].IpPermissions"
````
Expected: TCP port 3306 source referencing EC2 security group ID (not the CIDR)

List all security groups in a region
````sh
aws ec2 describe-security-groups \
  --region eu-west-1 \
  --query "SecurityGroups[].{GroupId:GroupId,Name:GroupName,VpcId:VpcId}" \
  --output table
````

Inspect a specific security group (inbound and outbound rules)
````sh
aws ec2 describe-security-groups \
  --group-ids sg-0123456789abcdef0 \
  --region eu-west-1 \
  --output json
````

Verify which resources are using the security group EC2 instances
````sh
aws ec2 describe-instances \
  --filters Name=instance.group-id,Values=sg-0123456789abcdef0 \
  --region eu-west-1 \
  --query "Reservations[].Instances[].InstanceId" \
  --output table
````

#### Step 3 : Create DB subnet group
- Go to Aurora and RDS > Subnet groups > Create DB subnet group
- Name your subnet group : lab-mysql-subnet
- Select the VPC that you want to associate with it in multiple AZs for availability's sake
- select the subnets (make sure they are all private)
- Click create
#### Step 4 : Create MySQL DB (private RDS)
- Aurora and RDS > Databases > Create database
- Full configuration
- Engine : MySQL
- Engine version : choose latest version
- Template : Free tier
- DB Instance identifier : lab-mysql
- Master username : admin
- Credentials management : self-managed
- Master password : (insertyourpassword)
- Instance configuration : burstable class - db.t4g.micro
- Connectivity : Don't connect to an EC2 compute resource
- Network type : IPv4
- VPC : select your VPC (irish-armageddon)
- DB subnet group : select your DB subnet group (lab-mysql-subnet)
- Public access : No
- VPC security group : Choose existing
- Existing VPC security groups : rds-lab-sg (switch off the default)
- Availability zone : no preference
- Create database
##### Run the following checks to verify your RDS instance

Verify RDS Instance State
````sh
aws rds describe-db-instances  
--db-instance-identifier lab-mysql  
--query "DBInstances[].DBInstanceStatus"
````
This should return back "Available"

Verify RDS Endpoint (Connectivity Target)
````sh
aws rds describe-db-instances  
--db-instance-identifier lab-mysql  
--query "DBInstances[].Endpoint"
````
This should return back the endpoint address port 3306

Verify which DB instance has a specific security group attached
````sh
aws rds describe-db-instances \
  --region eu-west-1 \
  --query "DBInstances[?contains(VpcSecurityGroups[].VpcSecurityGroupId, 'sg-0123456789abcdef0')].DBInstanceIdentifier" \
  --output table
````

List all RDS instances
````sh
aws rds describe-db-instances \
  --region eu-west-1 \
  --query "DBInstances[].{DB:DBInstanceIdentifier,Engine:Engine,Public:PubliclyAccessible,Vpc:DBSubnetGroup.VpcId}" \
  --output table
````

Inspect a specific RDS instance
````sh
aws rds describe-db-instances \
  --db-instance-identifier lab-mysql \
  --region eu-west-1 \
  --output json
````

Verify RDS security groups explicitly
````sh
aws rds describe-db-instances \
  --db-instance-identifier lab-mysql \
  --region eu-west-1 \
  --query "DBInstances[].VpcSecurityGroups[].VpcSecurityGroupId" \
  --output table
````

Verify RDS subnet placement
````sh
aws rds describe-db-subnet-groups \
  --region eu-west-1 \
  --query "DBSubnetGroups[].{Name:DBSubnetGroupName,Vpc:VpcId,Subnets:Subnets[].SubnetIdentifier}" \
  --output table
````

Verify network exposure (check if RDS is publicly reachable)
````sh
aws rds describe-db-instances \
  --db-instance-identifier mydb01 \
  --region us-east-1 \
  --query "DBInstances[].PubliclyAccessible" \
  --output text
````

#### Step 5: Store DB creds (Secrets Manager)
- AWS secret manager > secrets
- secret type : creds for RDS database
- secrets name : lab/rds/mysql
- username : admin
- password : (enter the password)
##### Run the following checks to check the Secrets Manager DB credential stores

Verify secrets manager
````sh
aws secretsmanager list-secrets \
  --region eu-west-1 \
  --query "SecretList[].{Name:Name,ARN:ARN,Rotation:RotationEnabled}" \
  --output table
````

Describe a specific secret (with no value exposure)
````sh
aws secretsmanager describe-secret \
  --secret-id lab/rds/mysql \
  --region eu-west-1 \
  --output json
````

#### Step 6 : Create IAM policy 
- IAM > Policies > create policy
Create IAM policy for EC2 role to allow EC2 to read the secret
- EC2-see-secret
- see inline policy JSON and attach it to it

````sh
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
````

#### Step 7 : Create IAM role for policy
- Trusted entity type : AWS service
- Use case : EC2
- Add permissions : ec2-see-secret
- Role name : ec2-see-secret-role
- Create role

##### Verify which IAM principals can access the secret
````sh
aws secretsmanager get-resource-policy \
  --secret-id lab/rds/mysql \
  --region eu-west-1 \
  --output json
````

Verify IAM role permissions (CRITICAL); list policies attached to the role
````sh
aws iam list-attached-role-policies \
  --role-name ec2-see-secret-role \
  --output table
````

List inline policies
````sh
aws iam list-role-policies \
  --role-name ec2-see-secret-role \
  --output table
````

Inspect a specific managed policy
````sh
aws iam get-policy-version \
  --policy-arn arn:aws:iam::aws:policy/SecretsManagerReadWrite \
  --version-id v1 \
  --output json
````

#### Step 8 : Bootstrap the EC2
- EC2 > Instance > Launch instance
- Name : ec2-lab-app
- AMI : Amazon Linux
- Instance type : t3.micro
- Key pair : choose or create your key pair
- Network settings:
	- Edit > VPC : irish-armageddon (choose your created VPC)
	- Choose your subnet (make sure it's public)
	- Auto-assign public IP : enable
	- Choose security group : ec2-lab-sg
- Advanced details:
	- IAM instance profile : ec2-see-secret-role
	- User data : insert your user data script (see below for eu-west-1 script)

````sh
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

REGION = os.environ.get("AWS_REGION", "eu-west-1")
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
    db = c.get("dbname", "lab-mysql")  # we'll create this if it doesn't exist
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
    cur.execute("CREATE DATABASE IF NOT EXISTS lab-mysql;")
    cur.execute("USE lab-mysql;")
    cur.execute("""
        CREATE TABLE IF NOT EXISTS notes (
            id INT AUTO_INCREMENT PRIMARY KEY,
            note VARCHAR(255) NOT NULL
        );
    """)
    cur.close()
    conn.close()
    return "Initialized lab-mysql + notes table."

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
Environment=AWS_REGION=eu-west-1
Environment=AWS_DEFAULT_REGION=eu-west-1
ExecStart=/usr/bin/python3 /opt/rdsapp/app.py
Restart=always

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable rdsapp
systemctl start rdsapp
````

##### Run the following checks to verify your EC2 instance

Verify the EC2 instance:
````sh
aws ec2 describe-instances
--filters "Name=tag:Name,Values=ec2-lab-app"
--query "Reservations[].Instances[].InstanceId" Expected: Instance ID returned Instance state = running
````

Verify IAM Role attached to the EC2:
````sh
aws ec2 describe-instances
--instance-ids <INSTANCE_ID>
--query "Reservations[].Instances[].IamInstanceProfile.Arn"
````
This should return the ARN of an IAM instance profile
##### Run the following checks from inside the EC2

Verify secrets manager access
````sh
aws secretsmanager get-secret-value  
--secret-id lab/rds/mysql
````
Expected: JSON containing username / password, host, port
If this fails then the IAM is misconfigured

Verify database connectivity 
````sh
sudo dnf install -y mysql

mysql -h <RDS_ENDPOINT> -u admin -p
````
Expected: successful login, no timeout or connection refused errors
##### Verify IAM role attached to an EC2 instance 
````sh
aws ec2 describe-instances \
  --filters Name=tag:Name,Values=ec2-lab-app \
  --region eu-west-1 \
  --query "Reservations[].Instances[].InstanceId" \
  --output text
````
Expected output : the EC2 instance ID

Take the instance ID and input it here
````sh
aws ec2 describe-instances \
  --instance-ids i-0123456789abcdef0 \
  --region eu-west-1 \
  --query "Reservations[].Instances[].IamInstanceProfile.Arn" \
  --output text
````
Expected : ARN of the IAM role attached to the EC2 instance
#### Step 9 : Test that all is well with the app
- copy the DB endpoint from RDS console
- open browser and check:
	- http://<EC2_public_ip>/init
	- http://<EC2_public_ip>/add?note=first_note
	- http://<EC2_public_ip>/list

Verify ECs > RDS access path (security group to security group)
````sh
aws ec2 describe-security-groups \
  --group-ids ec2-lab-sg \
  --region eu-west-1 \
  --query "SecurityGroups[].IpPermissions"
````

Verify that EC2 can actually read the secret (from inside of the instance - whether via SSH or AWS Cloudshell)
````sh
aws sts get-caller-identity
````

Then test access...
````sh
aws secretsmanager describe-secret \
  --secret-id lab/rds/mysql \
  --region eu-west-1
````

If this works then the IAM role is attached and the permissions are effective

#### TROUBLESHOOTING
As per TheoWAF: If /init hangs or errors, it’s almost always
- RDS SG inbound not allowing from EC2 SG on 3306
- RDS not in same VPC/subnets routing-wise
- EC2 role missing secretsmanager:GetSecretValue
- Secret doesn’t contain host / username / password fields (fix by storing as “Credentials for RDS database”)

### Deliverables

#### CLI command checks

##### To check Lab 1a, run the following steps in succession:

1) From your workstation (metadata checks; role attach + secret exists)

    chmod +x gate_secrets_and_role.sh
    REGION=us-east-1 INSTANCE_ID=i-0123456789abcdef0 SECRET_ID=my-db-secret ./gate_secrets_and_role.sh

From inside the EC2 instance (prove the instance role can actually read the secret)

    CHECK_SECRET_VALUE_READ=true REGION=us-east-1 INSTANCE_ID=i-0123456789abcdef0 SECRET_ID=my-db-secret ./gate_secrets_and_role.sh

Strict mode: require rotation enabled

    REQUIRE_ROTATION=true REGION=us-east-1 INSTANCE_ID=i-0123456789abcdef0 SECRET_ID=my-db-secret ./gate_secrets_and_role.sh


2) Basic: verify RDS isn’t public + SG-to-SG rule exists

    chmod +x gate_network_db.sh
    REGION=us-east-1 INSTANCE_ID=i-0123456789abcdef0 DB_ID=mydb01 ./gate_network_db.sh


Strict: also verify DB subnets are private (no IGW route)

CHECK_PRIVATE_SUBNETS=true REGION=us-east-1 INSTANCE_ID=i-0123456789abcdef0 DB_ID=mydb01 ./gate_network_db.sh

If endpoint port discovery fails, override it

DB_PORT=5432 REGION=us-east-1 INSTANCE_ID=i-0123456789abcdef0 DB_ID=mydb01 ./gate_network_db.sh

##### Or.... all in 1

chmod +x run_all_gates.sh
REGION=eu-west-1 \
INSTANCE_ID=i-0123456789abcdef0 \
SECRET_ID=my-db-secret \
DB_ID=mydb01 \
./run_all_gates.sh

Strict options (rotation + private subnet check)

REQUIRE_ROTATION=true \
CHECK_PRIVATE_SUBNETS=true \
REGION=us-east-1 INSTANCE_ID=i-... SECRET_ID=... DB_ID=... \
./run_all_gates.sh

If running ON the EC2 and you want to assert it can read the secret value

CHECK_SECRET_VALUE_READ=true \
REGION=us-east-1 INSTANCE_ID=i-... SECRET_ID=... DB_ID=... \
./run_all_gates.sh


Expected Output:
Files created:
        gate_secrets_and_role.json
        gate_network_db.json
        gate_result.json ✅ combined summary

Exit code:
        0 = ready to merge / ready to grade
        2 = fail (exact reasons provided)
        1 = error (missing env/tools/scripts)


#### Student Deliverables:

1. Screenshot of: 
	1. RDS SG inbound rule using source = ec2-lab-sg 

![[ec2-lag-sg inbound rules and sg-id.png]]

![[rds-lab-sg with ec2-lab-sg as inbound.png]]

	2. EC2 role attached 

![[ec2-see-secret policy.png]]

![[ec2-see-secret-role.png]]

	3. /list output showing at least 3 notes

![[RDS list.png]]

2. Short answers: 
	1. Why is DB inbound source restricted to the EC2 security group? 
	2. What port does MySQL use? 
		1. Port 3306
	3. Why is Secrets Manager better than storing creds in code/user-data?
		1. You have reduced exposure by having the creds in Secrets Manager instead of user data. You also have the ability for the secrets to be loaded at runtime and, with IAM roles needed to read them and KMS encryption, you have the knowledge that they are encrypted both at rest and in transit. You can also rotate creds as needed automatically should you have the need to. 
    
3. Evidence for Audits / Labs (Recommended Output)
    
    aws ec2 describe-security-groups --group-ids sg-0123456789abcdef0 > sg.json aws rds describe-db-instances --db-instance-identifier mydb01 > rds.json aws secretsmanager describe-secret --secret-id my-db-secret > secret.json aws ec2 describe-instances --instance-ids i-0123456789abcdef0 > instance.json aws iam list-attached-role-policies --role-name MyEC2Role > role-policies.json
    

![[Lab1a Run all gates check passed.png]]



Then Answer: 
- Why each rule exists 
- What would break if removed 
- Why broader access is forbidden 
- Why this role exists 
- Why it can read this secret 
- Why it cannot read others

---


