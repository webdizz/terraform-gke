variable "region" {
  default = "europe-west4"
}

variable "zone" {
  default = "europe-west4-a"
}

variable "network_name" {
  default = "gke-k8s-net"
}

variable "k8s-version" {
  default = "1.11.5-gke.4"
}

variable "external-white-cidr" {
  type = "list"
}

variable "k8s-max-nodes" {
  default = 2
}

variable "ci-mid-max-nodes" {
  default = 1
}

variable "cluster_name" {}

variable "project_name" {}
variable "sfx" {}
