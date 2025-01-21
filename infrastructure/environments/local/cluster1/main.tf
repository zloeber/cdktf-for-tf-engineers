terraform {
  required_version = ">= 1.0.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
  }
  backend "local" {
    path = "../../../../secrets/local/cluster1_tfstate.json"
  }
}

variable "env" {
  description = "The environment to deploy to."
  type        = string
  default     = "local"
}

variable "cluster_name" {
  description = "The name of the cluster to create."
  type        = string
  default     = "cluster1"
}


variable "kubeconfig" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "~/.kube/cluster1_config"
}

provider "kubernetes" {
  config_path = pathexpand(var.kubeconfig)
}

provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kubeconfig)
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

module "ssh_key" {
  source    = "../../../modules/self-signed-cert"
  name      = var.cluster_name
  root_path = pathexpand("../../../../secrets/${var.env}/")
}

resource "kubernetes_secret" "argocd_ssh_key" {
  metadata {
    name      = "argocd-ssh-key"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }
  data = {
    ssh-privatekey = module.ssh_key.private_key_pem
    ssh-publickey  = module.ssh_key.public_key_path
    # ssh-privatekey = base64encode(file(module.ssh_key.private_key_path))
    # ssh-publickey  = base64encode(file(module.ssh_key.public_key_path))
  }
  type = "kubernetes.io/ssh-auth"
  depends_on = [ module.ssh_key ]
}

resource "helm_release" "argocd" {
  chart            = "argo-cd"
  create_namespace = false
  description      = "ArgoCD Helm Chart"
  name             = "argo"
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  upgrade_install  = true
  values = [
    templatefile("${path.module}/config.yml", {
      argocd_server_url = "https://argocd-server.argocd.svc.cluster.local"
    })
  ]
  depends_on = [
    kubernetes_namespace.argocd,
  ]
  wait = false
}
