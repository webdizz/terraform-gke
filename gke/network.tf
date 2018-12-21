resource "google_compute_network" "default" {
  provider                = "google-beta"
  name                    = "${var.network_name}${var.sfx}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  provider                 = "google-beta"
  name                     = "${var.network_name}${var.sfx}-sub"
  ip_cidr_range            = "10.127.0.0/20"
  network                  = "${google_compute_network.default.self_link}"
  region                   = "${var.region}"
  private_ip_google_access = true
}

resource "google_compute_router" "gke-nat-router" {
  provider = "google-beta"
  name     = "nat-router${var.sfx}"
  region   = "${var.region}"
  network  = "${google_compute_network.default.self_link}"
}

resource "google_compute_router_nat" "default" {
  provider                           = "google-beta"
  name                               = "private-nat${var.sfx}"
  router                             = "${google_compute_router.gke-nat-router.name}"
  region                             = "${var.region}"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  # source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES"
}
