# IAM Role - Read DB Secret
resource "aws_iam_role" "read_db_secret" {
  name               = "read-db-secret-role-${local.name_suffix}"
  assume_role_policy = data.aws_iam_policy_document.read_db_secret_assume_role.json
  description        = "EC2 role that reads a db secret."

  tags = {
    Name        = "read-db-secret-role"
    Component   = "iam"
    DataClass   = "confidential"
    AccessLevel = "read-only"
  }
}

# Trust Policy Data for Read DB Secret role
data "aws_iam_policy_document" "read_db_secret_assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Policy Attachment - Read DB Secret --> Read DB Secret role
resource "aws_iam_role_policy_attachment" "attach_read_db_secret" {
  role       = aws_iam_role.read_db_secret.name
  policy_arn = aws_iam_policy.read_db_secret.arn
}