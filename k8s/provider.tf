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

resource "kubernetes_cluster_role_binding" "jenkins-sa-cluster-admin" {
  metadata {
    name = "jenkins-sa-cluster-admin"
  }

  role_ref {
    kind = "ClusterRole"
    name = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "${kubernetes_service_account.jenkins.metadata.0.name}"
    namespace = "${kubernetes_namespace.ci-cd.metadata.0.name}"
    api_group = ""
  }
}
resource "kubernetes_cluster_role_binding" "jenkins-sa-" {
  metadata {
    name = "setup-ci-cd-permissions"
  }

  role_ref {
    kind = "ClusterRole"
    name = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "${kubernetes_service_account.jenkins.metadata.0.name}"
    namespace = "${kubernetes_namespace.ci-cd.metadata.0.name}"
    api_group = ""
  }
}
