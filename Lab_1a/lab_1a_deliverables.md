# Deliverables

## RDS Security Group

<img src="./images/private_db_sg.png" alt="Private DB Security Group" width="90%">


## Attached IAM Role

<img src="./images/iam_role_attached.png" alt="Private DB Security Group" width="90%">



## Short Answers<br>

**A:** The database inbound traffic is restricted to the EC2 security group to keep the database from being exposed to unnecessary connections. Using this setup only allows traffic that is inbound from the EC2 security group. This minimizes the attack surface on the database and is a security best practice.

**B:** MySQL uses port 3306

**C:** Storing credentials in code/user-data is insecure because it exposes secrets to entities that have access to the code. If the code or script is exposed, the secret may also be exposed if hard coded as plain text. Secrets manager is much more secure because the credentials are stored and encrypted. The encrypted secret can be retrieved by entities with permission and automatically decrypted when authenticating, but the underlying plain text secret is never revealed. A secrets manager can also manage secret rotation to automatically update secrets. This is more secure and reduces overhead.

### Additional Answers:

**Why each rule exists:** Each security group exists to control the flow of traffic in your VPC. Security groups are a stateful firewall that help you restrict the flow of traffic and protect your resources.

**What would break if removed:<br>**<br>
**EC2 Security Group**
- Inbound Traffic: If these rules were removed, the web app wouldn't be accessible to the public via HTTP (Port 80) or through trusted IP via SSH (22)
- Outbound Traffic: Black hole. The EC2 couldn't communicate with anything in our outside of the VPC.<br>
**Database Security Group**
- Inbound Traffic: If the inbound traffic rule was removed MySQL (Port 3306) the EC2 instance wouldn't be able to communicate with the RDS instance.

Why broader access is forbidden:
- Broader access to the EC2 instance (SSH only via trusted IP) and RDS instance (MySQL only via EC2 security group) is forbidden because it violates the rule of least privilege. Expanding access exposes the resources to attackers, and can also put sensitive information at risk of exposure.

**Why this role exists:**
- The IAM Role exists so the EC2 instance itself doesn't have long term access to the credentials stored in the secret. Creating a role helps limit access and exposure of the secrets. The EC2 only assumes the role when needed, which reduces risk. It's also more scalable since new EC2 instances can assume the same role with  little added overhead.

**Why it can read this secret:**
- The EC2 can read the secret because its has the IAM Role assigned to it. The IAM Role contains permission policies that grant permission to perform the action required to retrieve the secret. Spefically the `secretsmanager:GetSecretValue` command.

**Why it cannot read others:**
- The EC2 can't read other secrets because the policy in the IAM role specifically limits it to secrets that follow this prefix : `arn:aws:secretsmanager:<REGION>:<ACCOUNT_ID>:secret:lab/rds/mysql*"`
- If the secret ARN was hardcoded without the wildcard, it would be further limited to that one specific resource. To read other secrets, more resource ARNS would have to be included in the policy.


List all security groups in a region

    aws ec2 describe-security-groups \
      --region us-east-1 \
      --query "SecurityGroups[].{GroupId:GroupId,Name:GroupName,VpcId:VpcId}" \
      --output table

Inspect a specific security group (inbound & outbound rules)

    aws ec2 describe-security-groups \
      --group-ids sg-0123456789abcdef0 \
      --region us-east-1 \
      --output json

Verify which resources are using the security group
EC2 instances

    aws ec2 describe-instances \
      --filters Name=instance.group-id,Values=sg-0123456789abcdef0 \
      --region us-east-1 \
      --query "Reservations[].Instances[].InstanceId" \
      --output table

RDS instances

    aws rds describe-db-instances \
      --region us-east-1 \
      --query "DBInstances[?contains(VpcSecurityGroups[].VpcSecurityGroupId, 'sg-0123456789abcdef0')].DBInstanceIdentifier" \
      --output table

List all RDS instances

    aws rds describe-db-instances \
      --region us-east-1 \
      --query "DBInstances[].{DB:DBInstanceIdentifier,Engine:Engine,Public:PubliclyAccessible,Vpc:DBSubnetGroup.VpcId}" \
      --output table

Inspect a specific RDS instance

    aws rds describe-db-instances \
      --db-instance-identifier mydb01 \
      --region us-east-1 \
      --output json

Critical checks
    "PubliclyAccessible": false
    Correct VPC
    Correct subnet group
    Correct security groups

Verify RDS security groups explicitly

    aws rds describe-db-instances \
      --db-instance-identifier mydb01 \
      --region us-east-1 \
      --query "DBInstances[].VpcSecurityGroups[].VpcSecurityGroupId" \
      --output table

Verify RDS subnet placement

    aws rds describe-db-subnet-groups \
      --region us-east-1 \
      --query "DBSubnetGroups[].{Name:DBSubnetGroupName,Vpc:VpcId,Subnets:Subnets[].SubnetIdentifier}" \
      --output table

What you’re verifying
    Private subnets only
    No IGW route
    Correct AZ spread

Verify Network Exposure (Fast Sanity Checks)
Check if RDS is publicly reachable (quick flag)

    aws rds describe-db-instances \
      --db-instance-identifier mydb01 \
      --region us-east-1 \
      --query "DBInstances[].PubliclyAccessible" \
      --output text

Expected output: false
