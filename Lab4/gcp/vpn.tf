resource "google_compute_ha_vpn_gateway" "nihonmachi_vpngw01" {
  name    = "nihonmachi-vpngw01"
  region  = var.gcp_region
  network = google_compute_network.nihonmachi_vpc01.id
}

resource "google_compute_router" "nihonmachi_bgp_router01" {
  name    = "nihonmachi-bgp-router01"
  region  = var.gcp_region
  network = google_compute_network.nihonmachi_vpc01.id
  bgp {
    asn = 65000
  }
}

resource "google_compute_vpn_tunnel" "nihonmachi_tunnel01" {
  name                            = "nihonmachi-tunnel01"
  region                          = var.gcp_region
  vpn_gateway                     = google_compute_ha_vpn_gateway.nihonmachi_vpngw01.id
  vpn_gateway_interface           = 0
  peer_external_gateway_interface = 0
  peer_external_gateway           = google_compute_external_vpn_gateway.nihonmachi_aws_gw01.id
  shared_secret                   = "QG0wSgyX3yqDfh4wpO40lRI0PoXC1WI5"
  router                          = google_compute_router.nihonmachi_bgp_router01.name
  ike_version                     = 2
}

resource "google_compute_vpn_tunnel" "nihonmachi_tunnel02" {
  name                            = "nihonmachi-tunnel02"
  region                          = var.gcp_region
  vpn_gateway                     = google_compute_ha_vpn_gateway.nihonmachi_vpngw01.id
  vpn_gateway_interface           = 1
  peer_external_gateway_interface = 1
  peer_external_gateway           = google_compute_external_vpn_gateway.nihonmachi_aws_gw01.id
  shared_secret                   = "QjWord3zYorxaZfLzaTZ2dAQ3sHFyTbl"
  router                          = google_compute_router.nihonmachi_bgp_router01.name
  ike_version                     = 2
}

resource "google_compute_external_vpn_gateway" "nihonmachi_aws_gw01" {
  name            = "nihonmachi-aws-gw01"
  redundancy_type = "TWO_IPS_REDUNDANCY"
  interface {
    id         = 0
    ip_address = "13.159.103.10"
  }
  interface {
    id         = 1
    ip_address = "18.182.186.252"
  }
}

resource "google_compute_router_interface" "nihonmachi_if01" {
  name       = "nihonmachi-if01"
  router     = google_compute_router.nihonmachi_bgp_router01.name
  region     = var.gcp_region
  ip_range   = "169.254.12.2/30"
  vpn_tunnel = google_compute_vpn_tunnel.nihonmachi_tunnel01.name
}

resource "google_compute_router_interface" "nihonmachi_if02" {
  name       = "nihonmachi-if02"
  router     = google_compute_router.nihonmachi_bgp_router01.name
  region     = var.gcp_region
  ip_range   = "169.254.12.6/30"
  vpn_tunnel = google_compute_vpn_tunnel.nihonmachi_tunnel02.name
}

resource "google_compute_router_peer" "nihonmachi_peer01" {
  name                      = "nihonmachi-peer01"
  router                    = google_compute_router.nihonmachi_bgp_router01.name
  region                    = var.gcp_region
  peer_ip_address           = "169.254.12.1"
  peer_asn                  = 64512
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.nihonmachi_if01.name
}

resource "google_compute_router_peer" "nihonmachi_peer02" {
  name                      = "nihonmachi-peer02"
  router                    = google_compute_router.nihonmachi_bgp_router01.name
  region                    = var.gcp_region
  peer_ip_address           = "169.254.12.5"
  peer_asn                  = 64512
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.nihonmachi_if02.name
}
