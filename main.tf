module "gke" {
  source              = "./gke"
  cluster_name        = "gke-cluster"
  project_name        = "cicd-gke-jenkins-x"
  external-white-cidr = "${var.external-white-cidr}"
  sfx                 = "${var.sfx}"
}

variable "external-white-cidr" {
  type = "list"

  default = [{
    display_name = "any"
    cidr_block   = "1.2.1.2/32"
  }]
}

module "k8s" {
  source                 = "./k8s"
  host                   = "${module.gke.host}"
  client_certificate     = "${module.gke.client_certificate}"
  client_key             = "${module.gke.client_key}"
  cluster_ca_certificate = "${module.gke.cluster_ca_certificate}"
  username               = "${module.gke.master_admin_username}"
  password               = "${module.gke.master_admin_password}"
  sfx                    = "${var.sfx}"
}

variable "sfx" {
  default = "-cicd"
}
