provider "kubernetes" {
  version                = "~> 1.4"
  host                   = "${var.host}"
  client_key             = "${base64decode(var.client_key)}"
  client_certificate     = "${base64decode(var.client_certificate)}"
  cluster_ca_certificate = "${base64decode(var.cluster_ca_certificate)}"
}

resource "kubernetes_namespace" "ci-cd" {
  metadata {
    annotations {
      name = "ci-cd"
    }

    labels {
      dedicated = "ci-cd"
    }
  }
}

resource "kubernetes_service_account" "jenkins" {
  metadata {
    name = "jenkins"
  }
}
