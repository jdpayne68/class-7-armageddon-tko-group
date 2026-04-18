# ----------------------------------------------------------------
# OBSERVABILITY OUTPUTS — VPC Flow Logs
# ----------------------------------------------------------------

output "vpc_flow_log_group_arn" {
  description = "CloudWatch log group ARN for VPC flow logs."
  value       = aws_cloudwatch_log_group.vpc_flow_log.arn
}

# ----------------------------------------------------------------
# OBSERVABILITY OUTPUTS — WAF CloudWatch Log Groups
# ----------------------------------------------------------------

output "waf_firehose_log_group_arn" {
  description = "CloudWatch log group ARN for WAF Firehose logging."
  value       = try(aws_cloudwatch_log_group.waf_firehose_logs[0].arn, null)
}

output "waf_direct_log_group_arn" {
  description = "CloudWatch log group ARN for direct WAF logging."
  value       = try(aws_cloudwatch_log_group.waf_logs[0].arn, null)
}

output "waf_log_destination_arn" {
  description = "WAF logging destination ARN."
  value       = local.waf_log_destination_arn
}

# ----------------------------------------------------------------
# OBSERVABILITY OUTPUTS — ALB Access Logs S3 Bucket
# ----------------------------------------------------------------

output "alb_logs_bucket_id" {
  description = "ID of the ALB access logs S3 bucket."
  value       = try(aws_s3_bucket.alb_logs_bucket[0].id, null)
}

output "alb_logs_bucket_arn" {
  description = "ARN of the ALB access logs S3 bucket."
  value       = try(aws_s3_bucket.alb_logs_bucket[0].arn, null)
}

output "alb_logs_bucket_name" {
  description = "Name of the ALB access logs S3 bucket."
  value       = try(aws_s3_bucket.alb_logs_bucket[0].bucket, null)
}

# ----------------------------------------------------------------
# OBSERVABILITY OUTPUTS — WAF Log Bucket (Direct Logging)
# ----------------------------------------------------------------

output "waf_log_bucket_arn" {
  description = "ARN of the S3 bucket for WAF logs."
  value       = try(aws_s3_bucket.waf_logs_bucket[0].arn, null)
}

output "waf_log_bucket_id" {
  description = "ID of the S3 bucket for WAF logs."
  value       = try(aws_s3_bucket.waf_logs_bucket[0].id, null)
}

# ----------------------------------------------------------------
# OBSERVABILITY OUTPUTS — WAF Firehose Logs S3 Bucket
# ----------------------------------------------------------------

output "waf_firehose_log_bucket_name" {
  description = "Name of the S3 bucket for WAF Firehose logs."
  value       = try(aws_s3_bucket.waf_firehose_logs[0].bucket, null)
}

output "waf_firehose_log_bucket_arn" {
  description = "ARN of the S3 bucket for WAF Firehose logs."
  value       = try(aws_s3_bucket.waf_firehose_logs[0].arn, null)
}

output "waf_firehose_log_bucket_id" {
  description = "ID of the S3 bucket for WAF Firehose logs."
  value       = try(aws_s3_bucket.waf_firehose_logs[0].id, null)
}

# ----------------------------------------------------------------
# OBSERVABILITY OUTPUTS — Alerting SNS Topics
# ----------------------------------------------------------------

output "rds_failure_alert_topic_arn" {
  description = "SNS topic ARN for RDS failure alerts."
  value       = aws_sns_topic.rds_failure_alert.arn
}

output "app_to_rds_connection_failure_alert_topic_arn" {
  description = "SNS topic ARN for application-to-database connectivity alerts."
  value       = aws_sns_topic.app_to_rds_connection_failure_alert.arn
}

output "lab_mysql_auth_failure_alert_topic_arn" {
  description = "SNS topic ARN for database authentication failure alerts."
  value       = aws_sns_topic.lab_mysql_auth_failure_alert.arn
}

output "rds_app_alb_server_error_alert_topic_arn" {
  description = "SNS topic ARN for ALB 5xx server error alerts."
  value       = aws_sns_topic.rds_app_alb_server_error_alert.arn
}

# ----------------------------------------------------------------
# OBSERVABILITY OUTPUTS — Logging Configuration Summary
# ----------------------------------------------------------------

output "logging_configuration" {
  description = "Logging configuration and destinations for ALB, WAF, and VPC flow logs."
  sensitive   = false

  value = {
    alb_access_logs = {
      enabled = var.alb_log_s3

      bucket = {
        name = try(aws_s3_bucket.alb_logs_bucket[0].bucket, null)
        arn  = try(aws_s3_bucket.alb_logs_bucket[0].arn, null)
      }

      prefix = var.alb_log_s3 ? var.alb_access_logs_prefix : null
    }

    waf_direct_logs = {
      enabled = var.waf_log_mode.create_direct_resources

      bucket = {
        name = try(aws_s3_bucket.waf_logs_bucket[0].bucket, null)
        arn  = try(aws_s3_bucket.waf_logs_bucket[0].arn, null)
      }
    }

    waf_firehose_logs = {
      enabled = var.waf_log_mode.create_firehose_resources

      firehose = {
        name = try(aws_kinesis_firehose_delivery_stream.network_telemetry[0].name, null)
        arn  = try(aws_kinesis_firehose_delivery_stream.network_telemetry[0].arn, null)
      }

      destination = {
        bucket_arn = try(aws_s3_bucket.waf_firehose_logs[0].arn, null)
        prefix     = var.waf_log_mode.create_firehose_resources ? "waf-logs/" : null
      }

      cloudwatch_logs = {
        vpc_flow_logs = {
          name = aws_cloudwatch_log_group.vpc_flow_log.name
          arn  = aws_cloudwatch_log_group.vpc_flow_log.arn
        }

        waf_direct_logs = {
          enabled = var.waf_log_mode.create_direct_resources
          name    = try(aws_cloudwatch_log_group.waf_logs[0].name, null)
          arn     = try(aws_cloudwatch_log_group.waf_logs[0].arn, null)
        }

        waf_firehose_logs = {
          enabled = var.waf_log_mode.create_firehose_resources
          name    = try(aws_cloudwatch_log_group.waf_firehose_logs[0].name, null)
          arn     = try(aws_cloudwatch_log_group.waf_firehose_logs[0].arn, null)
        }
      }
    }
  }
}