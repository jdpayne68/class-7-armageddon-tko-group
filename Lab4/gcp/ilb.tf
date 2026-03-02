resource "google_compute_region_health_check" "nihonmachi_hc01" {
  name   = "nihonmachi-hc01"
  region = var.gcp_region
  https_health_check {
    port         = 443
    request_path = "/health"
  }
}

resource "google_compute_region_ssl_certificate" "nihonmachi_cert01" {
  name_prefix = "nihonmachi-cert01-"
  region      = var.gcp_region
  private_key = tls_private_key.nihonmachi_key01.private_key_pem
  certificate = tls_self_signed_cert.nihonmachi_cert01.cert_pem
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_backend_service" "nihonmachi_backend01" {
  name                  = "nihonmachi-backend01"
  region                = var.gcp_region
  protocol              = "HTTPS"
  health_checks         = [google_compute_region_health_check.nihonmachi_hc01.id]
  load_balancing_scheme = "INTERNAL_MANAGED"
  backend {
    group           = google_compute_region_instance_group_manager.nihonmachi_mig01.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

resource "google_compute_region_url_map" "nihonmachi_urlmap01" {
  name            = "nihonmachi-urlmap01"
  region          = var.gcp_region
  default_service = google_compute_region_backend_service.nihonmachi_backend01.id
}

resource "google_compute_region_target_https_proxy" "nihonmachi_httpsproxy01" {
  name             = "nihonmachi-httpsproxy01"
  region           = var.gcp_region
  url_map          = google_compute_region_url_map.nihonmachi_urlmap01.id
  ssl_certificates = [google_compute_region_ssl_certificate.nihonmachi_cert01.id]
}

resource "google_compute_forwarding_rule" "nihonmachi_fr01" {
  name                  = "nihonmachi-fr01"
  region                = var.gcp_region
  load_balancing_scheme = "INTERNAL_MANAGED"
  ip_protocol           = "TCP"
  port_range            = "443"
  network               = google_compute_network.nihonmachi_vpc01.id
  subnetwork            = google_compute_subnetwork.nihonmachi_subnet01.id
  target                = google_compute_region_target_https_proxy.nihonmachi_httpsproxy01.id
  depends_on            = [google_compute_subnetwork.nihonmachi_proxy_subnet01]
}