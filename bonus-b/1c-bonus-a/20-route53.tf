############################################
# Hosted Zone (optional creation)
############################################

# Explanation: A hosted zone is like claiming Kashyyyk in DNS—names here become law across the galaxy.
resource "aws_route53_zone" "armageddon_zone01" {
  count = var.manage_route53_in_terraform ? 1 : 0

  name = local.armageddon_zone_name

  tags = {
    Name = "${var.project_name}-zone01"
  }
}
