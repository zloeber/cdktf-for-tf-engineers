locals {
  ## in the future, we can read the config files and secrets from a central location
  # global_config         = jsondecode(file("${path.module}/../../../config/global.json"))
  # env_config            = jsondecode(file("${path.module}/../../../config/env.${var.env}.json"))
  # secret_config         = jsondecode(file("${path.module}/../../../secrets/${var.env}.json"))
  # kube_config_base_path = "${path.module}/../../../secrets/${var.env}/kube"
  # config                = merge(local.global_config, local.env_config)
  # kube_clusters         = local.config.kube_clusters
  # kube_map              = { for cluster in local.kube_clusters : cluster.name => cluster }
}

terraform {
  required_version = "~> 1.0.0"
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.7.0"
    }
    # k3d = {
    #   source  = "pvotal-tech/k3d"
    #   version = "0.0.7"
    # }
    # helm = {
    #   source  = "hashicorp/helm"
    #   version = "2.17.0"
    # }
  }
  backend "local" {
    path = "../../../secrets/local/tfstate.json"
  }
}

## Kind
module "cluster1" {
  source              = "../../modules/k8s-kind-cluster"
  cluster_name        = "cluster1"
  cluster_config_path = "../../../secrets/${var.env}/cluster1_config"
}

