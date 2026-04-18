# Instance Profiles

# Instance Profile - RDS App
resource "aws_iam_instance_profile" "rds_app" {
  name = "rds-app-instance-profile"
  role = aws_iam_role.rds_app.name

  tags = {
    Name        = "rds-app-instance-profile"
    Component   = "iam"
    AccessLevel = "read-and-write"
    Service     = "ec2"
    Scope       = "rds-app"
  }
}