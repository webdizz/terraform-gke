resource "google_container_cluster" "gke-cluster" {
  provider = "google-beta"
  name     = "jenkins-gke-cluster"

  network    = "${google_compute_network.default.name}"
  subnetwork = "${google_compute_subnetwork.default.name}"
  zone       = "${var.zone}"

  min_master_version = "${var.k8s-version}"
  node_version       = "${var.k8s-version}"

  remove_default_node_pool = true

  node_pool {
    name               = "default-pool"
    initial_node_count = 0
  }

  private_cluster_config {
    enable_private_nodes   = true
    master_ipv4_cidr_block = "10.0.0.0/28"
  }

  pod_security_policy_config {
    enabled = true
  }

  additional_zones = [
    "${var.region}-b",
    "${var.region}-c",
  ]

  addons_config {
    http_load_balancing {
      disabled = false
    }
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block = "/16"
  }

  # master_authorized_networks_config{
  #   cidr_blocks=""
  # }
}

# The following outputs allow authentication and connectivity to the GKE Cluster.
output "client_certificate" {
  value = "${google_container_cluster.gke-cluster.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.gke-cluster.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.gke-cluster.master_auth.0.cluster_ca_certificate}"
}

output "master_admin_password" {
  value = "${google_container_cluster.gke-cluster.master_auth.0.password}"
}

output "master_admin_username" {
  value = "${google_container_cluster.gke-cluster.master_auth.0.username}"
}

output "master public ip" {
  value = "${google_container_cluster.gke-cluster.endpoint}"
}

variable "k8s-version" {
  default = "1.11.5-gke.4"
}
