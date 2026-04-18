# ----------------------------------------------------------------
# TRANSIT GATEWAY — OUTPUTS
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# OUTPUTS — Core Resources
# ----------------------------------------------------------------

output "tgw_id" {
  description = "Transit Gateway ID."
  value       = aws_ec2_transit_gateway.main.id
}

output "tgw_route_table_id" {
  description = "TGW route table ID."
  value       = aws_ec2_transit_gateway_route_table.main_rt.id
}

output "tgw_attachment_id" {
  description = "VPC attachment ID."
  value       = aws_ec2_transit_gateway_vpc_attachment.vpc_attachment.id
}

# ----------------------------------------------------------------
# OUTPUTS — Metadata
# ----------------------------------------------------------------

output "tgw_name" {
  description = "Transit Gateway name."
  value       = aws_ec2_transit_gateway.main.tags["Name"]
}