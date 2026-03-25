# ----------------------------------------------------------------
# IAM — Roles (VPC Flow Logs)
# ----------------------------------------------------------------

# IAM Role - VPC Flow Log
resource "aws_iam_role" "vpc_flow_log_role" {
  provider = aws.regional

  name               = "vpc-flow-log-role-${var.name_suffix}"
  assume_role_policy = data.aws_iam_policy_document.vpc_flow_log_assume_role.json

  tags = merge(
    {
      Name        = "vpc-flow-log-role"
      Component   = "iam"
      DataClass   = "internal"
      AccessLevel = "write"
    },
    var.context.tags
  )
}

# ----------------------------------------------------------------
# IAM — Trust Policies (VPC Flow Logs Service)
# ----------------------------------------------------------------

# Trust Policy Data for VPC Flow Log role
data "aws_iam_policy_document" "vpc_flow_log_assume_role" {
  provider = aws.regional

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

# ----------------------------------------------------------------
# IAM — Role Policy Attachments (VPC Flow Logs)
# ----------------------------------------------------------------

# Policy Attachment - VPC Flow Log Assume Role --> Private Data Subnet Flow Log role
# Consider more informative and scalable naming for role policy attachments
resource "aws_iam_role_policy_attachment" "attach_vpc_flow_log_role_policy" {
  provider = aws.regional

  role       = aws_iam_role.vpc_flow_log_role.name
  policy_arn = aws_iam_policy.vpc_flow_log_role.arn
}