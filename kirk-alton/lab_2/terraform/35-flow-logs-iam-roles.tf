# ----------------------------------------------------------------
# IAM — VPC Flow Log Role
# ----------------------------------------------------------------

# IAM Role - VPC Flow Log
resource "aws_iam_role" "vpc_flow_log_role" {
  name               = "vpc-flow-log-role-${local.name_suffix}"
  assume_role_policy = data.aws_iam_policy_document.vpc_flow_log_assume_role.json

  tags = {
    Name        = "vpc-flow-log-role"
    Component   = "iam"
    DataClass   = "internal"
    AccessLevel = "write"
  }
}

# ----------------------------------------------------------------
# IAM — Trust Policy (VPC Flow Log Service)
# ----------------------------------------------------------------

# Trust Policy Data for VPC Flow Log role
data "aws_iam_policy_document" "vpc_flow_log_assume_role" {
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
# IAM — Role Policy Attachment (VPC Flow Log)
# ----------------------------------------------------------------

# Policy Attachment - VPC Flow Log Assume Role --> Private Data Subnet Flow Log role
# Consider more informative and scaleable way to name role policy attachment resources (Think about naming methods for roles with multiple policies. How to scope?)
resource "aws_iam_role_policy_attachment" "attach_vpc_flow_log_role_policy" {
  role       = aws_iam_role.vpc_flow_log_role.name
  policy_arn = aws_iam_policy.vpc_flow_log_role.arn
}
