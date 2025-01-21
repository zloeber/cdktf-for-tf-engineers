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
  required_version = ">= 1.0.0"
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

## K3d
# module "cluster1" {
#   source              = "../../modules/k8s-k3d-cluster"
#   cluster_name        = "cluster1"
#   cluster_config_path = "../../../secrets/${var.env}"
#   domain              = "localhost"
# }
# provider "kubernetes" {
#   alias                  = "cluster1"
#   host                   = module.cluster1.credentials[0].host
#   client_certificate     = module.cluster1.credentials[0].client_certificate
#   client_key             = module.cluster1.credentials[0].client_key
#   cluster_ca_certificate = module.cluster1.credentials[0].cluster_ca_certificate
# }

# provider "helm" {
#   alias = "cluster1"
#   kubernetes {
#     host                   = module.cluster1.credentials[0].host
#     client_certificate     = module.cluster1.credentials[0].client_certificate
#     client_key             = module.cluster1.credentials[0].client_key
#     cluster_ca_certificate = module.cluster1.credentials[0].cluster_ca_certificate
#   }
# }


# provider "kubernetes" {
#   alias                  = "cluster1"
#   host                   = module.cluster1.config.endpoint
#   client_certificate     = module.cluster1.config.client_certificate
#   client_key             = module.cluster1.config.client_key
#   cluster_ca_certificate = module.cluster1.config.cluster_ca_certificate
# }

# provider "helm" {
#   alias = "cluster1"
#   kubernetes {
#     host                   = module.cluster1.config.endpoint
#     client_certificate     = module.cluster1.config.client_certificate
#     client_key             = module.cluster1.config.client_key
#     cluster_ca_certificate = module.cluster1.config.cluster_ca_certificate
#   }
# }

# resource "kubernetes_namespace" "argocd" {
#   provider = kubernetes.cluster1
#   metadata {
#     name = "argocd"
#   }
# }

# resource "kubernetes_secret" "argocd_ssh_key" {
#   provider = kubernetes.cluster1
#   metadata {
#     name      = "argocd-ssh-key"
#     namespace = kubernetes_namespace.argocd.metadata[0].name
#   }
#   data = {
#     ssh-privatekey = base64encode(file(module.cluster1_ssh_key.private_key_path))
#     ssh-publickey  = base64encode(file(module.cluster1_ssh_key.public_key_path))
#   }
#   type = "kubernetes.io/ssh-auth"
# }

# module "cluster1_ssh_key" {
#   source    = "../../modules/self-signed-cert"
#   name      = "cluster1"
#   root_path = "../../../secrets/${var.env}/kube/keys/"
# }

# resource "helm_release" "argocd" {
#   provider         = helm.cluster1
  
#   chart            = "argo-cd"
#   create_namespace = false
#   description      = "ArgoCD Helm Chart - local - cluster1"
#   name             = "argo"
#   namespace        = "argocd"
#   repository       = "https://argoproj.github.io/argo-helm"
#   upgrade_install  = true
#   values = [
#     templatefile("${path.module}/cluster1/config.yml", {
#       argocd_server_url = "https://argocd-server.argocd.svc.cluster.local"
#     })
#   ]
#   depends_on = [
#     module.cluster1,
#     kubernetes_namespace.argocd,
#     module.cluster1_ssh_key
#   ]
#   wait = false
# }
