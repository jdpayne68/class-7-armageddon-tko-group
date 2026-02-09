Needed : 
- extend your EC2 to RDS app to include the following
	- dual secret storage
	- AWS systems manager parameter store
	- AWS secrets manager centralized logging via CloudWatch Logs Automated alarms when db connectivity fails
	- Incident response actions using previously saved values

This lab teaches you to design for failure so that you can detect it early and recover using stored configuration data. You will purposely store things in both [[Parameter Store]] and [[AWS Secrets Manager]]

[[Parameter Store]] - supports plaintext SecureString
[[AWS Secrets Manager]] - best for credentials, passwords, rotating secrets

1. Store DB values in Parameter Store
	1. Db endpoint - lab-mysql.c5cy0im2ymjr.eu-west-1.rds.amazonaws.com
	2. Db port - 3306
2. Store DB credentials in Secrets Manager
	1. username / password / host / port
3. Log application DB connection failures to CloudWatch Logs
	1. create log groups
	2. send logs to the log groups
4. Create a CloudWatch Alarm (agent) that triggers when failures exceed a threshold
	1. alarm name prefix : lab-db-connection
	2. expected state transitions to ALARM during failure
5. Simulate a DB outage or credential failure
6. Recover the system using saved parameters/secrets without redeploying EC2
	1. curl http://ec2publicip/list

---
Prerequisites : everything from Lab 1a is up and running

Step 1 : Store DB values in Parameter Store
- Head to AWS Systems Manager > Parameter Store > Create parameter
- Parameter 1 details :
	- Name : /lab/rds/mysql/password
	- Tier : standard (free tier)
	- Type : SecureString
	- KMS Key Source : My current account
	- KMS Key ID : alias/aws/ssm
- Parameter 2 details
	- Name : /lab/rds/mysql/notes/note1
	- Tier : standard (free tier)
	- Type : string
	- Data type : text
	- Value : enter note 1 value
- Parameter 3 details
	- Name : /lab/rds/mysql/notes/note2
	- Tier : standard (free tier)
	- Type : string
	- Data type : text
	- Value : enter note 2 value
- continue until the values for the db are stored

Step 2 : Store DB credentials in Secrets Manager
- This should already be done from lab 1a (lab/rds/mysql)

Step 3 : Setup CloudWatch agent to automatically and continuously collect logs on EC2
- Create the IAM role to attach to the EC2 instance
	- Since you can only have one IAM role on an EC2 instance you will need to go ahead and modify the one that was created for lab 1a
	- IAM dashboard > Roles > ec2-see-secret-role > Add permissions > Attach policies
		- select CloudWatchAgentAdminPolicy
		- select CloudWatchAgentServerPolicy
		- select AmazonSSMFullAccess 
		- Add policies
	- Confirm that the role is attached with the EC2 instance
	- In the EC2 console, select the running instance you would like to install CloudWatch Agent on then Actions > Monitor and Troubleshoot > Configure CloudWatch Agent
	- Go through the parameters for CloudWatch Agent
		- Review selected instances
		- Validate SSM agent : will tell you if agent is installed and functioning correctly
		- Validate IAM permissions.
			- If role does not have necessary policies then it will show up here as insufficient permissions otherwise you will see Sufficient permissions
		- Validate CloudWatch agent
			- if CloudWatch agent is not installed on this instance, then you
		- Select configuration
			- Agent configuration
				- Collection interval : 60
			- Metric configuration
				- Computer Optimizer memory
				- Memory
					- used percent
				- CPU
					- time idle
				- Process
					- stopped
					- sleeping
					- idle
					- dead
					- blocked
				- Network interface
					- err in
					- err out
			- Logs configuration
				- Log stream name : ec2-lab-app-CWAgent-logs
				- Application Signals : enable
			- Complete
	- Go to CloudWatch Dashboard > Metrics
		- CWAgent should be showing up here under custom namespaces
	- CloudWatch > Log management > aws/rds/instance/lab-mysql/error
		- Filter pattern : ERROR. Click next
		- Filter name : rds-connection-error
		- Metric namespace : Lab/RDSapp
		- Metric name : DBConnectionErrors
		- Metric value : 1
		- Review and create metric filter

Step 4 : Set up CloudWatch to monitor RDS connections
- Enable enhanced monitoring for RDS
	- Go to Aurora & RDS > Databases and select the database you want to monitor
	- Under Monitoring tab, click Modify next to database insights
	- Scroll down to Monitoring and confirm that Database Insights is set to standard
	- Go to Additional monitoring settings
		- Enable enhanced monitoring
		- OS metrics : 60 seconds
		- Monitoring role for OS metrics : rds-monitoring-role
		- Log exports:
			- error log
			- general log
			- iam-db-auth-error log
		- Next > Schedule modifications : apply immediately

Step 6 : Create SNS topic for CloudWatch Threshold Notifications
- Go to Amazon SNS > Topics > Create topic
- Name topic then click Create a topic
- Type : standard
- Name : High-db-connections-lab-mysql
- Encryption : enable
- Access policy : basic
- Create topic
- Copy topic ARN : arn:aws:sns:eu-west-1:339712848647:High-db-connections-lab-mysql
- Create subscription
	- Protocol : email
	- Amazon SNS > Topics > (your topic) > Subscription (Send a notification to the following SNS topic)
		- select an existing SNS topic > select your preferred topic
		- Protocol : email 
			- enter your notification email destination
			- check email and confirm subscription

Step 7 : Create CloudWatch alarm for high connection threshold met
- Head to CloudWatch > Alarms > Create alarm
- Metric
	- Namespace : AWS/RDS
	- Metric name : DatabaseConnections
	- DBInstanceIdentifier : lab-mysql
	- Statistic : Average
	- Period : 7 days
- Conditions
	- Threshold type : static
	- Whenever databaseconnections is Greater/Equal than 3
- Configure actions
	- Alarm trigger state : in alarm

Step 8 : Create CloudWatch alarm for database connection failure
- Head to CloudWatch > Alarms > Create alarm
- Metric
	- Namespace : AWS/RDS
	- Metric name : IamDbAuthConnectionFailureServerError
	- DBInstanceIdentifier : lab-mysql
	- Statistic : Maximum
	- Period : 7 days
- Conditions
	- Threshold type : static
	- Whenever IamDbAuthConnectionFailureServerError is Greater/Equal than 1
- Configure actions
	- Alarm trigger state : in alarm



---
Incident Runbook (must follow this order otherwise points are getting docked)

#### Runbook Section 1 - 
Acknowledge 1.1 Confirm Alert

Type the following into the CLI
````sh
aws cloudwatch describe-alarms --alarm-names database-connection0failure-lab-mysql --query "MetricAlarms[].StateValue"
````

At this point you are expecting it to say ALARM. From here we will go on and figure out what the cause of the alarm is and what needs to be done to get everything up and running

#### Runbook Section 2 - Observe 2.1 Check Application Logs

Check the logs for any error patterns by inserting the following
````sh
  aws logs filter-log-events \
  --log-group-name /aws/rds/instance/lab-mysql/error \
  --filter-pattern "ERROR"
````

This should pull up your exact DB connection failure messages and provide a clue as to what exactly is not going well

LOG FAILURE MESSAGE:
IDENTIFIED FAILURE TYPE BASED ON THIS MESSAGE:
#### Runbook Section 3 - Validate Configuration Sources 3.1 Retrieve Parameter Store values

Validate configuration sources (retrieve parameter store values)
````sh
  aws ssm get-parameters \
    --names /lab/db/endpoint /lab/db/port /lab/db/name \
    --with-decryption
````

This should return your endpoint & port

Retrieve Secrets Manager value
````sh
  aws secretsmanager get-secret-value \
  --secret-id lab/rds/mysql
````

This will show the username / password combination visibly. Compare this against the known "good state" user/password combo

#### Runbook Section 4 - Containment 

It's key at this point to not rotate secrets blindly or restart the EC2 or redeploy any infrastructure. You NEED to know what the issue is. 

System state preserved for recovery.

#### Runbook Section 5 - Recovery Paths

If credential drift: update the RDS password to match Secrets Manager OR Update Secrets Manager to known-good value

````sh
If network block
	Restore EC2 security group access to RDS on 3306
	
If DB stopped
	Start RDS and wait for available	
````

Verify Recovery curl http://ec2_public_ipv4/list

Application should return data with no errors

#### Runbook Section 6 

Post incident validation (confirm alarms are clear)
````sh
aws cloudwatch describe-alarms \
--alarm-name lab-db-connection-failure \
--query "MetricAlarms[].StateValue"
````

This should send back an OK message. If not, repeat above steps until it does

Confirm logs normalize
````sh
aws logs filter-log-events \
  --log-group-name /aws/ec2/lab-rds-app \
  --filter-pattern "ERROR"
````
Expected ; no new errors