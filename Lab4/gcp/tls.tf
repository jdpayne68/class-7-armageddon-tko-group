resource "tls_private_key" "nihonmachi_key01" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "nihonmachi_cert01" {
  private_key_pem = tls_private_key.nihonmachi_key01.private_key_pem
  subject {
    common_name = "nihonmachi-internal.local"
  }
  validity_period_hours = 8760
  allowed_uses          = ["key_encipherment", "digital_signature", "server_auth"]
}
