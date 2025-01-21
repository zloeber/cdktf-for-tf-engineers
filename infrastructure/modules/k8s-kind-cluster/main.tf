locals {
  cluster_config = "${var.cluster_config_path}/${var.cluster_name}_config"
}

terraform {
  required_version = ">= 1.0.0"
  required_providers {

    kind = {
      source  = "tehcyx/kind"
      version = "0.7.0"
    }
  }
}


resource "kind_cluster" "this" {
  name           = var.cluster_name
  kubeconfig_path    = pathexpand(var.cluster_config_path)
  wait_for_ready = true
}
