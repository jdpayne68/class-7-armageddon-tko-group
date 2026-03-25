# ----------------------------------------------------------------
# TRANSIT GATEWAY PEERING — OUTPUTS
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# OUTPUTS — Peering Attachment
# ----------------------------------------------------------------

output "tgw_peering_attachment_id" {
  description = "TGW peering attachment ID."
  value       = aws_ec2_transit_gateway_peering_attachment.tgw_peering_request.id
}