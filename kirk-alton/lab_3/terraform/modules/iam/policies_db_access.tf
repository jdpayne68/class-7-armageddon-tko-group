# ----------------------------------------------------------------
# IAM — Policies (Database Access)
# ----------------------------------------------------------------

# IAM Policy Object - Read DB Secret
resource "aws_iam_policy" "read_db_secret" {
  provider = aws.regional

  name        = "read-db-secret-${var.name_suffix}"
  path        = "/"
  description = "Read specific secret for db."

  policy = data.aws_iam_policy_document.read_db_secret.json

  tags = merge(
    {
      Name      = "read-db-secret"
      Component = "iam"
      DataClass = "confidential"
    },
    var.context.tags
  )
}

# IAM Policy Data - Read DB Secret
data "aws_iam_policy_document" "read_db_secret" {
  provider = aws.regional
  statement {
    sid    = "ReadDBSecret"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      var.db_secret_arn,
      "${var.db_secret_arn}-*"
    ]
  }
}

# ----------------------------------------------------------------
# IAM — Policies (Database Parameters)
# ----------------------------------------------------------------

# IAM Policy Object - Read DB Name Parameter
resource "aws_iam_policy" "read_db_name_parameter" {
  provider = aws.regional

  name        = "read-db-name-parameter-${var.name_suffix}"
  path        = "/"
  description = "Allows EC2 to read DB name from SSM Parameter Store"

  policy = data.aws_iam_policy_document.read_db_name_parameter.json

  tags = merge(
    {
      Name         = "read-db-name-parameter"
      Component    = "iam"
      AppComponent = "credentials"
      DataClass    = "internal"
      AccessLevel  = "read-only"
    },
    var.context.tags
  )
}

# IAM Policy Data - Read DB Name Parameter
data "aws_iam_policy_document" "read_db_name_parameter" {
  provider = aws.regional

  statement {
    sid    = "ReadDbNameParameter"
    effect = "Allow"

    actions = [
      "ssm:GetParameter",
      "ssm:GetParametersByPath"
    ]

    resources = [
      "arn:aws:ssm:${local.region}:${local.account_id}:parameter/lab/rds/mysql/db-name-${var.name_suffix}"
    ]
  }
}

# IAM Policy Object - Read DB Username Parameter
resource "aws_iam_policy" "read_db_username_parameter" {
  provider = aws.regional

  name        = "read-db-username-parameter-${var.name_suffix}"
  path        = "/"
  description = "Allows EC2 to read DB username from SSM Parameter Store"

  policy = data.aws_iam_policy_document.read_db_username_parameter.json

  tags = merge(
    {
      Name         = "read-db-username-parameter"
      Component    = "iam"
      AppComponent = "credentials"
      DataClass    = "internal"
      AccessLevel  = "read-only"
    },
    var.context.tags
  )
}

# IAM Policy Data - Read DB Username Parameter
data "aws_iam_policy_document" "read_db_username_parameter" {
  provider = aws.regional

  statement {
    sid    = "ReadDbUsernameParameter"
    effect = "Allow"

    actions = [
      "ssm:GetParameter",
      "ssm:GetParametersByPath"
    ]

    resources = [
      "arn:aws:ssm:${local.region}:${var.account_id}:parameter/lab/rds/mysql/db-username-${var.name_suffix}"
    ]
  }
}

# IAM Policy Object - Read DB Host Parameter
resource "aws_iam_policy" "read_db_host_parameter" {
  provider = aws.regional

  name        = "read-db-host-parameter-${var.name_suffix}"
  path        = "/"
  description = "Allows EC2 to read DB host from SSM Parameter Store"

  policy = data.aws_iam_policy_document.read_db_host_parameter.json

  tags = merge(
    {
      Name         = "read-db-host-parameter"
      Component    = "iam"
      AppComponent = "credentials"
      DataClass    = "internal"
      AccessLevel  = "read-only"
    },
    var.context.tags
  )
}

# IAM Policy Data - Read DB Host Parameter
data "aws_iam_policy_document" "read_db_host_parameter" {
  provider = aws.regional

  statement {
    sid    = "ReadDbHostParameter"
    effect = "Allow"

    actions = [
      "ssm:GetParameter",
      "ssm:GetParametersByPath"
    ]

    resources = [
      "arn:aws:ssm:${local.region}:${var.account_id}:parameter/lab/rds/mysql/db-host-${var.name_suffix}"
    ]
  }
}

# IAM Policy Object - Read DB Port Parameter
resource "aws_iam_policy" "read_db_port_parameter" {
  provider = aws.regional

  name        = "read-db-port-parameter-${var.name_suffix}"
  path        = "/"
  description = "Allows EC2 to read DB port from SSM Parameter Store"

  policy = data.aws_iam_policy_document.read_db_port_parameter.json

  tags = merge(
    {
      Name         = "read-db-port-parameter"
      Component    = "iam"
      AppComponent = "credentials"
      DataClass    = "internal"
      AccessLevel  = "read-only"
    },
    var.context.tags
  )
}

# IAM Policy Data - Read DB Port Parameter
data "aws_iam_policy_document" "read_db_port_parameter" {
  provider = aws.regional

  statement {
    sid    = "ReadDbPortParameter"
    effect = "Allow"

    actions = [
      "ssm:GetParameter",
      "ssm:GetParametersByPath"
    ]

    resources = [
      "arn:aws:ssm:${local.region}:${var.account_id}:parameter/lab/rds/mysql/db-port-${var.name_suffix}"
    ]
  }
}