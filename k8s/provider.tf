provider "kubernetes" {
  version                = "~> 1.4"
  host                   = "${var.host}"
  client_key             = "${base64decode(var.client_key)}"
  client_certificate     = "${base64decode(var.client_certificate)}"
  cluster_ca_certificate = "${base64decode(var.cluster_ca_certificate)}"
  username               = "${var.username}"
  password               = "${var.password}"
}

resource "kubernetes_namespace" "ci-cd" {
  metadata {
    name = "ci-cd"

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
    name      = "jenkins"
    namespace = "${kubernetes_namespace.ci-cd.metadata.0.name}"
  }
}
