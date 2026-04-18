# ----------------------------------------------------------------
# TOKYO MAIN — MODULES
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# MODULE — NETWORK
# ----------------------------------------------------------------

module "network" {
  source = "../../../modules/network"

  providers = {
    aws.regional = aws
  }

  # Identity and Naming
  context     = local.context
  account_id  = local.account_id
  name_prefix = local.name_prefix
  name_suffix = local.name_suffix

  # VPC Configuration
  vpc_cidr = var.vpc_cidr
  azs      = local.azs

  # Demo Metadata (Not used for deployment)
  demo_owner = var.demo_owner #DEMO: Root variable var.demo_owner is passed into module variable demo_owner
}

# ----------------------------------------------------------------
# MODULE — SECURITY
# ----------------------------------------------------------------

module "security" {
  source = "../../../modules/security"

  providers = {
    aws.regional = aws
  }

  # Identity and Naming
  context     = local.context
  account_id  = local.account_id
  name_prefix = local.name_prefix
  name_suffix = local.name_suffix

  # VPC Context
  vpc_cidr = module.network.vpc_cidr
  vpc_id   = module.network.vpc_id

  # WAF
  create_waf = false

  # WAF Logging Configuration
  waf_log_retention_days             = var.waf_log_retention_days
  enable_waf_sampled_requests_only   = var.enable_waf_sampled_requests_only
  enable_direct_service_log_delivery = var.enable_direct_service_log_delivery

  waf_log_mode            = local.waf_log_mode
  waf_log_destination_arn = module.observability.waf_log_destination_arn
  waf_log_bucket_id       = module.observability.waf_log_bucket_id
  waf_log_bucket_arn      = module.observability.waf_log_bucket_arn
}

# ----------------------------------------------------------------
# MODULE — IAM
# ----------------------------------------------------------------

module "iam" {
  source = "../../../modules/iam"

  providers = {
    aws.regional = aws
  }

  # Identity and Naming
  context     = local.context
  account_id  = local.account_id
  name_prefix = local.name_prefix
  name_suffix = local.name_suffix

  # Logging Permissions
  enable_direct_service_log_delivery = module.security.enable_direct_service_log_delivery
  waf_log_mode                       = local.waf_log_mode

  # Log Destinations
  # Always-on → direct
  vpc_flow_log_group_arn   = module.observability.vpc_flow_log_group_arn
  waf_direct_log_group_arn = module.observability.waf_direct_log_group_arn

  # Conditional (Firehose) → guarded
  waf_firehose_log_group_arn  = try(module.observability.waf_firehose_log_group_arn, null)
  waf_firehose_log_bucket_arn = try(module.observability.waf_firehose_logs_bucket_arn, null)

  # Secrets Access
  db_secret_arn = module.database.db_secret_arn
}

# ----------------------------------------------------------------
# MODULE — DATABASE
# ----------------------------------------------------------------

module "database" {
  source = "../../../modules/database"

  providers = {
    aws.regional = aws
  }

  # Identity and Naming
  context     = local.context
  name_prefix = local.name_prefix
  name_suffix = local.name_suffix

  # Security Groups
  private_db_sg_id = module.security.private_db_sg_id

  # Database Configuration
  db_engine   = local.normalized_db_engine
  db_username = var.db_username

  # Network Subnets
  private_app_subnet_ids  = module.network.private_app_subnet_ids
  private_data_subnet_ids = module.network.private_data_subnet_ids

  # Subnet Metadata
  private_app_subnet_tags  = module.network.private_app_subnet_tags
  private_data_subnet_tags = module.network.private_subnet_tags

  # Monitoring and Alerting
  rds_enhanced_monitoring_role_arn = module.iam.rds_enhanced_monitoring_role_arn
  rds_failure_alert_topic_arn      = module.observability.rds_failure_alert_topic_arn

  # Secrets
  db_secret_arn = module.database.db_secret_arn
}

# ----------------------------------------------------------------
# MODULE — COMPUTE
# ----------------------------------------------------------------

module "compute" {
  source = "../../../modules/compute"

  providers = {
    aws.regional = aws
  }

  # Identity and Naming
  context     = local.context
  name_prefix = local.name_prefix
  name_suffix = local.name_suffix

  # DNS Context
  dns_context = local.dns_context

  # VPC Context
  vpc_id = module.network.vpc_id

  # Security Groups
  rds_app_asg_sg_id = module.security.rds_app_asg_sg_id
  alb_origin_sg_id  = module.security.alb_origin_sg_id

  # IAM Roles
  iam_role_rds_app_name         = module.iam.rds_app_role_name
  rds_app_instance_profile_name = module.iam.rds_app_instance_profile_name

  # Network Subnets
  public_subnet_ids      = module.network.public_subnet_ids
  private_app_subnet_ids = module.network.private_app_subnet_ids

  # Subnet Metadata
  public_subnet_tags      = module.network.public_subnet_tags
  private_app_subnet_tags = module.network.private_app_subnet_tags

  # Application Secrets
  db_secret_arn = module.database.db_secret_arn

  # ALB Logging
  alb_access_logs_prefix = var.alb_access_logs_prefix
  alb_log_s3             = var.alb_log_s3
  alb_logs_bucket_id     = module.observability.alb_logs_bucket_id

  # Edge Integration
  edge_auth_header_name = local.edge_auth_header_name
  edge_auth_value       = random_password.edge_auth_value.result

  # Network Dependencies
  ec2_vpc_endpoints_ready = module.network.ec2_vpc_endpoints_ready

  # AMI ID
  ami_id = var.ami_id

  zone_id = module.dns.zone_id

  # Certificate Validation — Regional TLS (ALB)
  #rds_app_cert_validation_fqdns = module.compute.rds_app_cert_validation_fqdns
}

# ----------------------------------------------------------------
# MODULE — DNS
# ----------------------------------------------------------------

module "dns" {
  source = "../../../modules/dns"

  providers = {
    aws.regional = aws
  }

  # Identity and Naming
  context     = local.context
  name_prefix = local.name_prefix
  name_suffix = local.name_suffix

  # DNS Context
  dns_context = local.dns_context

  # Route53 Configuration
  manage_route53_in_terraform = var.manage_route53_in_terraform # Tokyo (Hub) will manage Rout53 decisions.
  route53_private_zone        = var.route53_private_zone
  is_dns_writer               = var.is_dns_writer

  # ALB (Origin)
  rds_app_public_alb_dns_name = module.compute.alb_dns_name
  rds_app_public_alb_zone_id  = module.compute.alb_zone_id
}


# ----------------------------------------------------------------
# MODULE — OBSERVABILITY
# ----------------------------------------------------------------

module "observability" {
  source = "../../../modules/observability"

  providers = {
    aws.regional = aws
  }

  # Identity and Naming
  context       = local.context
  account_id    = local.account_id
  name_prefix   = local.name_prefix
  name_suffix   = local.name_suffix
  bucket_suffix = local.bucket_suffix

  # Network Context
  vpc_id = module.network.vpc_id

  # ALB Logging
  alb_access_logs_prefix = var.alb_access_logs_prefix
  alb_log_s3             = var.alb_log_s3

  # Database Monitoring
  enable_db_observability = var.enable_db_observability
  db_identifier           = module.database.db_identifier

  # Compute Metrics
  rds_app_public_alb_arn_suffix = module.compute.rds_app_public_alb_arn_suffix
  rds_app_asg_tg_arn_suffix     = module.compute.rds_app_asg_tg_arn_suffix
  rds_app_asg_name              = module.compute.rds_app_asg_name

  # WAF Integration
  waf_log_mode     = local.waf_log_mode
  rds_app_waf_name = module.security.rds_app_waf_name
  rds_app_waf_arn  = module.security.rds_app_waf_arn

  # IAM Integration
  vpc_flow_log_role_arn = module.iam.vpc_flow_log_role_arn
}

# ----------------------------------------------------------------
# MODULE — TRANSIT GATEWAY (TOKYO HUB)
# ----------------------------------------------------------------

module "tgw" {
  source = "../../../modules/tgw"

  providers = {
    aws.regional = aws
  }

  # Identity and Naming
  context     = local.context
  name_prefix = local.name_prefix
  name_suffix = local.name_suffix

  # TGW Role
  tgw_role = var.tgw_role

  # Networking
  vpc_id = module.network.vpc_id

  private_app_subnet_ids = module.network.private_app_subnet_ids

  # Tagging
  tgw_tags = var.tgw_tags
}