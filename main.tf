module "gke" {
  source = "./gke"
}

module "k8s" {
  source                 = "./k8s"
  host                   = "${module.gke.host}"
  client_certificate     = "${module.gke.client_certificate}"
  client_key             = "${module.gke.client_key}"
  cluster_ca_certificate = "${module.gke.cluster_ca_certificate}"
  username               = "${module.gke.master_admin_username}"
  password               = "${module.gke.master_admin_password}"
}
