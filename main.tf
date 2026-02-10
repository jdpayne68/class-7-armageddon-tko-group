############################################
# Terraform configuration - Ground zero for abebe’s infrastructure
############################################

provider "aws" {
  region = var.aws_region
}

# Required providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.18.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
  }
}


############################################
# Locals (naming convention: abebe-*)
############################################
locals {
  name_prefix = var.project_name
  user_data = templatefile("user_data.sh", {
    ssm_cloudwatch_config = aws_ssm_parameter.abebe_cw_agent.name
  })
}

############################################
# Data Blocks for use here (for pulling AZs)
############################################

data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

############################################
# VPC + Internet Gateway
############################################

# Explanation: abebe needs a hyperlane—this VPC is the Millennium Falcon’s flight corridor.
resource "aws_vpc" "abebe_vpc01" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name      = "${local.name_prefix}-vpc01"
    Terraform = "true"
    Region    = data.aws_region.current.region
  }
}

# Explanation: Even Wookiees need to reach the wider galaxy—IGW is your door to the public internet.
resource "aws_internet_gateway" "abebe_igw01" {
  vpc_id = aws_vpc.abebe_vpc01.id

  tags = {
    Name   = "${local.name_prefix}-igw01"
    Region = data.aws_region.current.region
  }
}

############################################
# Subnets (Public + Private)
############################################

# Explanation: Public subnets are like docking bays—ships can land directly from space (internet).
resource "aws_subnet" "abebe_public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.abebe_vpc01.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name_prefix}-public-subnet0${count.index + 1}"
  }
}

# Explanation: Private subnets are the hidden Rebel base—no direct access from the internet.
resource "aws_subnet" "abebe_private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.abebe_vpc01.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${local.name_prefix}-private-subnet0${count.index + 1}"
  }
}

############################################
# NAT Gateway + EIP
############################################

# Explanation: abebe wants the private base to call home—EIP gives the NAT a stable “holonet address.”
resource "aws_eip" "abebe_nat_eip01" {
  domain = "vpc"

  tags = {
    Name = "${local.name_prefix}-nat-eip01"
  }
}

# Explanation: NAT is abebe’s smuggler tunnel—private subnets can reach out without being seen.
resource "aws_nat_gateway" "abebe_nat01" {
  allocation_id = aws_eip.abebe_nat_eip01.id
  subnet_id     = aws_subnet.abebe_public_subnets[0].id # NAT in a public subnet

  tags = {
    Name = "${local.name_prefix}-nat01"
  }

  depends_on = [aws_internet_gateway.abebe_igw01]
}

############################################
# Routing (Public + Private Route Tables)
############################################

# Explanation: Public route table = “open lanes” to the galaxy via IGW.
resource "aws_route_table" "abebe_public_rt01" {
  vpc_id = aws_vpc.abebe_vpc01.id

  tags = {
    Name = "${local.name_prefix}-public-rt01"
  }
}

# Explanation: This route is the Kessel Run—0.0.0.0/0 goes out the IGW.
resource "aws_route" "abebe_public_default_route" {
  route_table_id         = aws_route_table.abebe_public_rt01.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.abebe_igw01.id
}

# Explanation: Attach public subnets to the “public lanes.”
resource "aws_route_table_association" "abebe_public_rta" {
  count          = length(aws_subnet.abebe_public_subnets)
  subnet_id      = aws_subnet.abebe_public_subnets[count.index].id
  route_table_id = aws_route_table.abebe_public_rt01.id
}

# Explanation: Private route table = “stay hidden, but still ship supplies.”
resource "aws_route_table" "abebe_private_rt01" {
  vpc_id = aws_vpc.abebe_vpc01.id

  tags = {
    Name = "${local.name_prefix}-private-rt01"
  }
}

# Explanation: Private subnets route outbound internet via NAT (abebe-approved stealth).
resource "aws_route" "abebe_private_default_route" {
  route_table_id         = aws_route_table.abebe_private_rt01.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.abebe_nat01.id
}

# Explanation: Attach private subnets to the “stealth lanes.”
resource "aws_route_table_association" "abebe_private_rta" {
  count          = length(aws_subnet.abebe_private_subnets)
  subnet_id      = aws_subnet.abebe_private_subnets[count.index].id
  route_table_id = aws_route_table.abebe_private_rt01.id
}

############################################
# Security Groups (EC2 + RDS)
############################################

# Explanation: EC2 SG is abebe’s bodyguard—only let in what you mean to.
resource "aws_security_group" "abebe_ec2_sg01" {
  name        = "${local.name_prefix}-ec2-sg01"
  description = "EC2 app security group"
  vpc_id      = aws_vpc.abebe_vpc01.id

  tags = {
    Name = "${local.name_prefix}-ec2-sg01"
  }
}

# TODO: student adds inbound rules (HTTP 80, SSH 22 from their IP)
# TODO: student ensures outbound allows DB port to RDS SG (or allow all outbound)

resource "aws_vpc_security_group_ingress_rule" "abebe_ec2_ingress_http01" {
  security_group_id = aws_security_group.abebe_ec2_sg01.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80

}

resource "aws_vpc_security_group_ingress_rule" "abebe_ec2_ingress_ssm01" {
  security_group_id = aws_security_group.abebe_ec2_sg01.id
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  cidr_ipv4         = var.ip_address # TODO: student replaces with their IP
}

resource "aws_vpc_security_group_egress_rule" "abebe_ec2_egress_all01" {
  security_group_id = aws_security_group.abebe_ec2_sg01.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}



# Explanation: RDS SG is the Rebel vault—only the app server gets a keycard.
resource "aws_security_group" "abebe_rds_sg01" {
  name        = "${local.name_prefix}-rds-sg01"
  description = "RDS security group"
  vpc_id      = aws_vpc.abebe_vpc01.id
}

resource "aws_vpc_security_group_ingress_rule" "abebe_rds_ingress_mysql01" {
  security_group_id            = aws_security_group.abebe_rds_sg01.id
  from_port                    = 3306
  ip_protocol                  = "tcp"
  to_port                      = 3306
  referenced_security_group_id = aws_security_group.abebe_ec2_sg01.id # TODO: student adds inbound MySQL 3306 from aws_security_group.abebe_ec2_sg01.id
}

resource "aws_vpc_security_group_egress_rule" "abebe_rds_egress_all01" {
  security_group_id = aws_security_group.abebe_rds_sg01.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}


############################################
# RDS Subnet Group
############################################

# Explanation: RDS hides in private subnets like the Rebel base on Hoth—cold, quiet, and not public.
resource "aws_db_subnet_group" "abebe_rds_subnet_group01" {
  name       = "${local.name_prefix}-rds-subnet-group01"
  subnet_ids = aws_subnet.abebe_private_subnets[*].id

  tags = {
    Name = "${local.name_prefix}-rds-subnet-group01"
  }
}

############################################
# RDS Instance (MySQL)
############################################

# Explanation: This is the holocron of state—your relational data lives here, not on the EC2.
resource "aws_db_instance" "abebe_rds01" {
  identifier        = "${local.name_prefix}-rds01"
  engine            = var.db_engine
  instance_class    = var.db_instance_class
  allocated_storage = 20
  db_name           = var.db_name
  username          = var.db_username
  password          = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.abebe_rds_subnet_group01.name
  vpc_security_group_ids = [aws_security_group.abebe_rds_sg01.id]

  publicly_accessible = false
  skip_final_snapshot = true
  multi_az            = true

  # TODO: student sets multi_az / backups / monitoring as stretch goals

  tags = {
    Name = "${local.name_prefix}-rds01"
  }
}

############################################
# IAM Role + Instance Profile for EC2 (and CloudWatch Agent)
############################################

# Explanation: abebe refuses to carry static keys—this role lets EC2 assume permissions safely.
resource "aws_iam_role" "abebe_ec2_role01" {
  name = "${local.name_prefix}-ec2-role01"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# Explanation: These policies are your Wookiee toolbelt—tighten them (least privilege) as a stretch goal.
resource "aws_iam_role_policy_attachment" "abebe_ec2_ssm_attach" {
  role       = aws_iam_role.abebe_ec2_role01.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Explanation: EC2 must read secrets/params during recovery—give it access (students should scope it down).
resource "aws_iam_role_policy_attachment" "abebe_ec2_secrets_attach" {
  role       = aws_iam_role.abebe_ec2_role01.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite" # TODO: student replaces w/ least privilege
}

# Explanation: CloudWatch role needed in order to attach the policy below.
resource "aws_iam_role" "abebe_ec2_cw_role01" {
  name = "${local.name_prefix}-ec2-cw-role01"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

# Explanation: CloudWatch logs are the “ship’s black box”—you need them when things explode. Attach the policy to the abebe_ec2_role01 to manage logs.
resource "aws_iam_role_policy_attachment" "abebe_ec2_cw_attach" {
  role       = aws_iam_role.abebe_ec2_role01.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Explanation: Instance profile is the harness that straps the role onto the EC2 like bandolier ammo.
resource "aws_iam_instance_profile" "abebe_instance_profile01" {
  name = "${local.name_prefix}-instance-profile01"
  role = aws_iam_role.abebe_ec2_role01.name
}

############################################
# EC2 Instance (App Host)
############################################

# Explanation: This is your “Han Solo box”—it talks to RDS and complains loudly when the DB is down.
resource "aws_instance" "abebe_ec2_01" {
  ami                    = var.ec2_ami_id
  instance_type          = var.ec2_instance_type
  user_data              = local.user_data
  subnet_id              = aws_subnet.abebe_public_subnets[0].id
  vpc_security_group_ids = [aws_security_group.abebe_ec2_sg01.id]
  iam_instance_profile   = aws_iam_instance_profile.abebe_instance_profile01.name

  tags = {
    Name = "${local.name_prefix}-ec2-01"
  }
}



# TODO: student supplies user_data to install app + CW agent + configure log shipping
# user_data = file("${path.module}/user_data.sh")


############################################
# Parameter Store (SSM Parameters)
############################################

# Explanation: Parameter Store is abebe’s map—endpoints and config live here for fast recovery.
resource "aws_ssm_parameter" "abebe_db_endpoint_param" {
  name  = "/lab/db/endpoint"
  type  = "String"
  value = aws_db_instance.abebe_rds01.address
  overwrite = true

  tags = {
    Name = "${local.name_prefix}-param-db-endpoint"
  }
}

# Explanation: Ports are boring, but even Wookiees need to know which door number to kick in.
resource "aws_ssm_parameter" "abebe_db_port_param" {
  name  = "/lab/db/port"
  type  = "String"
  value = tostring(aws_db_instance.abebe_rds01.port)

  tags = {
    Name = "${local.name_prefix}-param-db-port"
  }
}

# Explanation: DB name is the label on the crate—without it, you’re rummaging in the dark.
resource "aws_ssm_parameter" "abebe_db_name_param" {
  name  = "/lab/db/name"
  type  = "String"
  value = var.db_name
  overwrite = true

  tags = {
    Name = "${local.name_prefix}-param-db-name"
  }
}

# Explanation: CloudWatch Agent config to configure custom log
resource "aws_ssm_parameter" "abebe_cw_agent" {
  name  = "/lab/rds/mysql"
  type  = "String"
  value = tostring(aws_db_instance.abebe_rds01.address)

  tags = {
    Name = "${local.name_prefix}-param-cw-agent-config"
  }
}


############################################
# CloudWatch Logs (Log Group)
############################################

# Explanation: When the Falcon is on fire, logs tell you *which* wire sparked—ship them centrally.
resource "aws_cloudwatch_log_group" "abebe_log_group01" {
  name              = "/aws/ec2/${local.name_prefix}-rds-app"
  retention_in_days = 7

  tags = {
    Name = "${local.name_prefix}-log-group01"
  }
}

############################################
# Custom Metric + Alarm (Skeleton)
############################################

# Explanation: Metrics are abebe’s growls—when they spike, something is wrong.
# NOTE: Students must emit the metric from app/agent; this just declares the alarm.
resource "aws_cloudwatch_metric_alarm" "abebe_db_alarm01" {
  alarm_name          = "${local.name_prefix}-db-connection-failure"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "DBConnectionErrors"
  namespace           = "Lab/RDSApp"
  period              = 300
  statistic           = "Sum"
  threshold           = 3

  treat_missing_data = "notBreaching" # Missing data doesn't trigger the alarm

  alarm_actions = [aws_sns_topic.abebe_sns_topic01.arn]

  tags = {
    Name = "${local.name_prefix}-alarm-db-fail"
  }
}

############################################
# SNS (PagerDuty simulation)
############################################

# Explanation: SNS is the distress beacon—when the DB dies, the galaxy (your inbox) must hear about it.
resource "aws_sns_topic" "abebe_sns_topic01" {
  name = "${local.name_prefix}-db-incidents"
}

# Explanation: Email subscription = “poor man’s PagerDuty”—still enough to wake you up at 3AM.
resource "aws_sns_topic_subscription" "abebe_sns_sub01" {
  topic_arn = aws_sns_topic.abebe_sns_topic01.arn
  protocol  = "email"
  endpoint  = var.sns_email_endpoint
}

############################################
# Secrets Manager (DB Credentials)
############################################

# Explanation: Secrets Manager is abebe’s locked holster—credentials go here, not in code.
resource "aws_secretsmanager_secret" "lab_rds_mysql" {
  name = var.secret_id
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "lab_rds_mysql" {
  secret_id = "var.secret_id"
  secret_string = jsonencode({
    username             = var.db_username
    password             = var.db_password
    engine               = var.db_engine
    host                 = aws_db_instance.abebe_rds01.address
    port                 = aws_db_instance.abebe_rds01.port
    dbname               = var.db_name
  })
}


############################################
# (Optional but realistic) VPC Endpoints (Skeleton)
############################################

# Explanation: Endpoints keep traffic inside AWS like hyperspace lanes—less exposure, more control.
# TODO: students can add endpoints for SSM, Logs, Secrets Manager if doing “no public egress” variant.
# resource "aws_vpc_endpoint" "abebe_vpce_ssm" { ... }
