# IAM Role - Public App
resource "aws_iam_role" "public_app" {
  name               = "public-app-role-${local.name_suffix}"
  assume_role_policy = data.aws_iam_policy_document.public_app_assume_role.json
  description        = "EC2 role that reads a db secret."

  tags = {
    Name        = "public-app-role"
    Component   = "iam"
    DataClass   = "confidential"
    AccessLevel = "read-only"
  }
}

# Trust Policy Data for Public App role
data "aws_iam_policy_document" "public_app_assume_role" {
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

# Policy Attachment - Read DB Secret --> Public App role
resource "aws_iam_role_policy_attachment" "attach_read_db_secret" {
  role       = aws_iam_role.public_app.name
  policy_arn = aws_iam_policy.read_db_secret.arn
}

# Policy Attachment - Read DB Connection Parameters --> Public App role
resource "aws_iam_role_policy_attachment" "attach_read_db_connection_parameters" {
  role       = aws_iam_role.public_app.name
  policy_arn = aws_iam_policy.read_db_connection_parameters.arn
}
