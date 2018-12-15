resource "google_container_node_pool" "k8s-node-pool" {
  provider = "google-beta"
  name     = "k8s-node-pool"
  zone     = "${var.region}-a"

  cluster            = "${google_container_cluster.gke-cluster.name}"
  initial_node_count = 1

  autoscaling {
    min_node_count = 0
    max_node_count = 5
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type = "n1-standard-4"
    disk_size_gb = 50
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
    }

    taint = [
      {
        key    = "dedicated"
        value  = "k8s"
        effect = "NO_SCHEDULE"
      },
    ]
  }
}
