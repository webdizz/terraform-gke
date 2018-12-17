resource "google_container_cluster" "gke-cluster" {
  provider = "google-beta"
  name     = "jenkins-gke-cluster"

  network    = "${google_compute_network.default.name}"
  subnetwork = "${google_compute_subnetwork.default.name}"
  zone       = "${var.zone}"

  min_master_version = "${var.k8s-version}"
  node_version       = "${var.k8s-version}"

  node_pool {
    name               = "default-pool"
    initial_node_count = 1

    autoscaling {
      min_node_count = 2
      max_node_count = 5
    }

    management {
      auto_repair  = false
      auto_upgrade = false
    }

    node_config {
      machine_type = "n1-standard-2"
      disk_size_gb = 20
      disk_type    = "pd-standard"
      preemptible  = true
      image_type   = "COS"

      oauth_scopes = [
        "compute-rw",
        "storage-ro",
        "logging-write",
        "monitoring",
      ]

      labels {
        dedicated = "k8s"
        region    = "${var.region}"
        role      = "system"
      }
    }
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

  master_authorized_networks_config {
    cidr_blocks = [
      {
        cidr_block = "${var.external-white-cidr}"
      },
    ]
  }
}

# The following outputs allow authentication and connectivity to the GKE Cluster.
output "client_certificate" {
  value     = "${google_container_cluster.gke-cluster.master_auth.0.client_certificate}"
  sensitive = true
}

output "client_key" {
  value     = "${google_container_cluster.gke-cluster.master_auth.0.client_key}"
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = "${google_container_cluster.gke-cluster.master_auth.0.cluster_ca_certificate}"
  sensitive = true
}

output "master_admin_password" {
  value = "${google_container_cluster.gke-cluster.master_auth.0.password}"
}

output "master_admin_username" {
  value = "${google_container_cluster.gke-cluster.master_auth.0.username}"
}

output "host" {
  value = "${google_container_cluster.gke-cluster.endpoint}"
}
