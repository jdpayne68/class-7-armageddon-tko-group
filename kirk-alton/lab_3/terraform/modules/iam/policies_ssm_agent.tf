# ----------------------------------------------------------------
# IAM — Policies (SSM Agent)
# ----------------------------------------------------------------

# IAM Policy Object - SSM Agent Policy
resource "aws_iam_policy" "ssm_agent_policy" {
  provider = aws.regional

  name        = "${var.name_prefix}-ssm-agent-policy-${var.context.env}"
  path        = "/"
  description = "Allow SSM Agent Permissions"

  policy = data.aws_iam_policy_document.ssm_agent_policy.json

  tags = merge(
    {
      Name      = "ssm-agent-policy"
      Component = "instance-management"
    },
    var.context.tags
  )
}

# IAM Policy Data - SSM Agent Policy
# (SSM Agent Permissions, Messaging, and Legacy Messaging)
data "aws_iam_policy_document" "ssm_agent_policy" {
  provider = aws.regional

  statement {
    sid    = "AllowSSMAgentPermissions"
    effect = "Allow"

    actions = [
      "ssm:DescribeAssociation",
      "ssm:GetDeployablePatchSnapshotForInstance",
      "ssm:GetDocument",
      "ssm:DescribeDocument",
      "ssm:GetManifest",
      "ssm:ListAssociations",
      "ssm:ListInstanceAssociations",
      "ssm:PutInventory",
      "ssm:PutComplianceItems",
      "ssm:PutConfigurePackageResult",
      "ssm:UpdateAssociationStatus",
      "ssm:UpdateInstanceAssociationStatus",
      "ssm:UpdateInstanceInformation"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowSSMChannelMessaging"
    effect = "Allow"

    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowSSMLegacyMessaging"
    effect = "Allow"

    actions = [
      "ec2messages:AcknowledgeMessage",
      "ec2messages:DeleteMessage",
      "ec2messages:FailMessage",
      "ec2messages:GetEndpoint",
      "ec2messages:GetMessages",
      "ec2messages:SendReply"
    ]

    resources = ["*"]
  }
}