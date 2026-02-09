locals {
  # Account ID
  account_id = data.aws_caller_identity.current.account_id

  # VPC CIDR
  vpc_cidr = var.vpc_cidr

  # Environment setup
  env = lower(var.env)
  app = var.app

  # Route53
  root_domain   = var.root_domain
  app_subdomain = var.app
  fqdn          = "${local.app_subdomain}.${local.root_domain}"

  # Region and AZ
  region = var.region_map[var.region_choice]
  azs    = data.aws_availability_zones.available.names

  # Base Tags
  base_tags = {
    Environment = "${local.env}"
  }

  # Naming helpers
  name_prefix   = "${local.app}-${local.env}"
  name_suffix   = lower(random_string.suffix.result)
  bucket_suffix = random_id.bucket_suffix.hex


  # Subnet selection helpers
  subnet_index = random_integer.subnet_picker.result

  # Public Subnets
  public_subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id,
    aws_subnet.public_c.id
  ]
  # Public Subnet CIDRs
  public_subnet_cidrs = [
    aws_subnet.public_a.cidr_block,
    aws_subnet.public_b.cidr_block,
    aws_subnet.public_c.cidr_block
  ]

  # Assigns random public subnet from the list using shared random index
  random_public_subnet = local.public_subnets[local.subnet_index]


  # Shared tags for public subnets
  public_subnet_tags = {
    Exposure = "public"
    Egress   = "igw"
  }


  # Shared tags for vpc endpoints
  vpc_endpoint_tags = {
    Exposure  = "egress-only"
    Egress    = "vpc-endpoint"
    Component = "network"
  }


  # Private App Subnets
  private_app_subnets = [
    aws_subnet.private_app_a.id,
    aws_subnet.private_app_b.id,
    aws_subnet.private_app_c.id
  ]

  # Private App Subnet CIDRs
  private_app_subnet_cidrs = [
    aws_subnet.private_app_a.cidr_block,
    aws_subnet.private_app_b.cidr_block,
    aws_subnet.private_app_c.cidr_block
  ]

  # Assigns random private app subnet from the list using shared random index
  random_private_app_subnet = local.private_app_subnets[local.subnet_index]


  # Private Data Subnets
  private_data_subnets = [
    aws_subnet.private_data_a.id,
    aws_subnet.private_data_b.id,
    aws_subnet.private_data_c.id
  ]

  # Private Data Subnet CIDRs
  private_data_subnet_cidrs = [
    aws_subnet.private_data_a.cidr_block,
    aws_subnet.private_data_b.cidr_block,
    aws_subnet.private_data_c.cidr_block
  ]


  # Assigns random private data subnet from the list using shared random index
  random_private_data_subnet = local.private_data_subnets[local.subnet_index]

  # Shared tags for private subnets
  private_subnet_tags = {
    Exposure  = "internal-only"
    Egress    = "none"
    Component = "network"
  }

  # Template Files
  # EC2 User Data for RDS App Instances
  rds_app_user_data = templatefile("${path.module}/templates/1c_user_data.sh.tpl",
    {
      region      = local.region,
      secret_id   = local.secret_id
      name_suffix = local.name_suffix
    }
  )

  # CloudWatch Agent Configuration File
  cloudwatch_agent_config = templatefile("${path.module}/templates/cloudwatch-agent-config.json.tpl",
    {
      name_suffix = local.name_suffix
    }
  )


  # Other Locals

  # Security Group IDs
  alb_sg_id = aws_security_group.alb.id
  # rds_app_ec2_sg_id        = aws_security_group.rds_app_ec2.id
  rds_app_asg_sg_id = aws_security_group.rds_app_asg
  private_db_sg_id  = aws_security_group.private_db.id

  db_credentials = {
    username = "admin"
    password = random_password.db_password.result
  }

  secret_id = aws_secretsmanager_secret.lab_rds_mysql.arn


  # WAF Log Options Map
  waf_log_modes = {
    cloudwatch = {
      direct       = true
      use_firehose = false
      target       = "cloudwatch"
    }

    firehose = {
      direct       = false
      use_firehose = true
      target       = "firehose"
    }

    s3 = {
      direct       = true
      use_firehose = false
      target       = "s3"
    }
  }

  # WAF Log Destination ARN Resolution
  # This is abstracted from options map to prevent cycle loops with locals.
  # ? : Is the ternary conditional operator. condition ? value_if_true : value_if_false
  waf_log_destination_arn = (
    local.waf_log_mode.target == "cloudwatch" ? aws_cloudwatch_log_group.waf_logs.arn :
    local.waf_log_mode.target == "firehose" ? aws_kinesis_firehose_delivery_stream.network_telemetry.arn :
    local.waf_log_mode.target == "s3" ? aws_s3_bucket.waf_logs_bucket[0].arn :
    null
  )
  # Remember, everything in an expression () evaluates to ONE value.


  # WAF Log Mode Selection
  waf_log_mode = local.waf_log_modes[var.waf_log_destination]

  # WAF Log Mode Validation Logic
  # This will be false if both log modes are true.
  # A check against this value gives an error to prevent issues on apply.
  waf_log_mode_valid = (local.waf_log_mode.direct && !local.waf_log_mode.use_firehose) || (!local.waf_log_mode.direct && local.waf_log_mode.use_firehose)
}