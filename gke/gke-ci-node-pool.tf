resource "google_container_node_pool" "ci-mid-node-pool" {
  provider           = "google-beta"
  name               = "ci-mid-node${var.sfx}-pool"
  zone               = "${var.region}-a"
  cluster            = "${google_container_cluster.gke-cluster.name}"
  initial_node_count = 1

  autoscaling {
    min_node_count = 0
    max_node_count = "${var.ci-mid-max-nodes}"
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    image_type   = "COS"
    machine_type = "n1-highcpu-8"
    disk_size_gb = 50
    disk_type    = "pd-ssd"
    preemptible  = true

    oauth_scopes = [
      "compute-rw",
      "storage-ro",
      "logging-write",
      "monitoring",
    ]

    labels {
      dedicated = "ci-mid"
    }

    taint = [
      {
        key    = "dedicated"
        value  = "ci-mid"
        effect = "NO_SCHEDULE"
      },
    ]
  }
}
