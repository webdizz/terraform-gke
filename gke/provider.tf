provider "google-beta" {
  version     = "~> 1.20"
  credentials = "${file("${path.module}/terraform-sa.json")}"
  project     = "${var.project_name}"
  region      = "${var.region}"
}
