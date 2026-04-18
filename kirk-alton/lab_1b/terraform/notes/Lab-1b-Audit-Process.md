
# Verification

### Get Secret Parameters

``` bash
aws ssm get-parameters --names <endpoint-parameter-name> <port-parameter-name> <db-parameter-name> --with-decryption
```

### Verify Secrets Manager Value

``` bash
aws secretsmanager get-secret-value --secret-id <db-secret-name>
```

### SSH Into EC2

``` bash
ssh -i <key-path.pem> ec2-user@<public-ip>
```

### Verify EC2 Can Read Both Systems From EC2

``` bash
aws ssm get-parameter --name <endpoint-parameter-name>
aws secretsmanager get-secret-value --secret-id <db-secret-name>
```

---
## Simulate DB Authentication Errors

### Log into database with incorrect credentials to log errors.

``` bash
mysql -h <db-endpoint> -u wronguser -p'wrongpassword'
```

### Verify alarm state in console.

### Verify CloudWatch Log Groups (with alarm state)

```bash
aws logs describe-log-groups --log-group-name-prefix <log-group-name>
```

### Verify SNS Email.

### Verify DB Authentication Error Logs

``` bash
aws logs filter-log-events --log-group-name <log-group-name> --filter-pattern "Access denied for user"
```

---
## Simulate DB Connection Failure

### Remove EC2 SG Rule from DB SG.

### Repeatedly attempt to connect to the database (HTTP or SSH)

``` bash
mysql -h <db-endpoint> -u wronguser -p
```

### Verify alarm state in console.

### Verify CloudWatch Alarm

``` bash
aws cloudwatch describe-alarms --alarm-name-prefix <alarm-name>
```

### Verify DB Failure Logs (VPC Traffic REJECT)

``` bash
aws logs filter-log-events --log-group-name <log-group-name> --filter-pattern "REJECT"
```

---
## Incident Recovery Verification: After Restoring Connectivity and/or Credentials

``` bash
curl http://<ec2-public-ip>/list
```

> Make sure the app has posted at least three notes to the database. If no notes are posted, this command will fail.

