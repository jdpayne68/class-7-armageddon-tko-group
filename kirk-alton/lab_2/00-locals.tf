locals {
  # -------------------------------------------------------------------
  # Core Identity, Environment, and Naming
  # -------------------------------------------------------------------
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
}


locals {
  # -------------------------------------------------------------------
  # Subnet selection helpers
  # -------------------------------------------------------------------
  subnet_index = random_integer.subnet_picker.result

  # -------------------------------------------------------------------
  # Public Subnets
  # -------------------------------------------------------------------
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

  # Assigns random public subnet using shared random index
  random_public_subnet = local.public_subnets[local.subnet_index]

  # -------------------------------------------------------------------
  # Private Application Subnets
  # -------------------------------------------------------------------
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

  # Assigns random private app subnet using shared random index
  random_private_app_subnet = local.private_app_subnets[local.subnet_index]

  # -------------------------------------------------------------------
  # Private Data Subnets
  # -------------------------------------------------------------------
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

  # Assigns random private data subnet using shared random index
  random_private_data_subnet = local.private_data_subnets[local.subnet_index]


  # -------------------------------------------------------------------
  # Shared Network Tags
  # -------------------------------------------------------------------
  # Shared tags for public subnets
  public_subnet_tags = {
    Exposure = "public"
    Egress   = "igw"
  }

  # Shared tags for private subnets
  private_subnet_tags = {
    Exposure  = "internal-only"
    Egress    = "none"
    Component = "network"
  }


  # Shared tags for vpc endpoints
  vpc_endpoint_tags = {
    Exposure  = "egress-only"
    Egress    = "vpc-endpoint"
    Component = "network"
  }
}



locals {
  # Locals for Rendering Template Files

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
}



locals {
  # -------------------------------------------------------------------
  # Security & Identity
  # -------------------------------------------------------------------
  # Security Group IDs
  alb_sg_id = aws_security_group.alb_origin.id
  # rds_app_ec2_sg_id        = aws_security_group.rds_app_ec2.id
  rds_app_asg_sg_id = aws_security_group.rds_app_asg
  private_db_sg_id  = aws_security_group.private_db.id

  # Database Credentials
  db_credentials = {
    username = "admin"
    password = random_password.db_password.result # TODO: Update to vault key
  }

  # Secrets Manager
  secret_id = aws_secretsmanager_secret.lab_rds_mysql.arn
}



locals {
  # -------------------------------------------------------------------
  # Route53 Zone Resolution (Managed or Existing)
  # -------------------------------------------------------------------
  # Tries Terraform-managed hosted zone first.
  # If null (toggled off with variable), falls back to zone_id in the existing data source.
  route53_zone_id = coalesce(
    try(aws_route53_zone.terraform_managed_zone[0].zone_id, null),
    data.aws_route53_zone.rds_app_zone[0].zone_id, null
  )
}


locals {
  # -------------------------------------------------------------------
  # ALB Logging Configuration
  # -------------------------------------------------------------------
  alb_log_mode = var.enable_alb_access_logs

  # -------------------------------------------------------------------
  # WAF Logging Configuration
  # -------------------------------------------------------------------
  # WAF Log Mode Definitions
  waf_log_modes = {
    cloudwatch = {
      create_direct_resources   = true
      create_firehose_resources = false
      target                    = "cloudwatch"
    }

    firehose = {
      create_direct_resources   = false
      create_firehose_resources = true
      target                    = "firehose"
    }

    s3 = {
      create_direct_resources   = true
      create_firehose_resources = false
      target                    = "s3"
    }
  }

  # WAF Log Mode Selection
  waf_log_mode = local.waf_log_modes[var.waf_log_destination]

  # Resolve WAF Log Destination ARN
  # Kept separate from waf_log_modes to avoid dependency cycles.
  waf_log_destination_arn = (
    local.waf_log_mode.target == "cloudwatch" ? aws_cloudwatch_log_group.waf_logs[0].arn :
    local.waf_log_mode.target == "firehose" ? aws_kinesis_firehose_delivery_stream.network_telemetry[0].arn :
    local.waf_log_mode.target == "s3" ? aws_s3_bucket.waf_logs_bucket[0].arn :
    null
  )
  # ? : Is the ternary conditional operator. condition ? value_if_true : value_if_false
  # Remember, everything in an expression () evaluates to ONE value.

  # -------------------------------------------------------------------
  # Validation & Safety Logic
  # -------------------------------------------------------------------
  # WAF Log Mode Validation Logic
  # This will be false if both log modes are true.
  # A check against this value gives an error to prevent issues on apply.
  waf_log_mode_valid = (local.waf_log_mode.create_direct_resources && !local.waf_log_mode.create_firehose_resources) || (!local.waf_log_mode.create_direct_resources && local.waf_log_mode.create_firehose_resources)
}

locals {
  # Edge Authentication Header Name
  edge_auth_header_name = "X-${local.name_prefix}-edge-auth-v1" # Cycle versions as needed
}
