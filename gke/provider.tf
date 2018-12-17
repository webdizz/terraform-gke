provider "google-beta" {
  version     = "~> 1.20"
  credentials = "${file("${path.module}/terraform-sa.json")}"
  project     = "cicd-gke-jenkins-x"
  region      = "${var.region}"
}

resource "google_compute_network" "default" {
  provider                = "google-beta"
  name                    = "${var.network_name}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  provider                 = "google-beta"
  name                     = "${var.network_name}"
  ip_cidr_range            = "10.127.0.0/20"
  network                  = "${google_compute_network.default.self_link}"
  region                   = "${var.region}"
  private_ip_google_access = true
}
