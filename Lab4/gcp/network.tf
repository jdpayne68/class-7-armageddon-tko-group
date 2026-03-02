resource "google_compute_network" "nihonmachi_vpc01" {
  name                    = "nihonmachi-vpc01"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "nihonmachi_subnet01" {
  name                     = "nihonmachi-subnet01"
  ip_cidr_range            = var.nihonmachi_subnet_cidr
  region                   = var.gcp_region
  network                  = google_compute_network.nihonmachi_vpc01.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "nihonmachi_proxy_subnet01" {
  name          = "nihonmachi-proxy-subnet01"
  ip_cidr_range = "10.20.2.0/24"
  region        = var.gcp_region
  network       = google_compute_network.nihonmachi_vpc01.id
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
}