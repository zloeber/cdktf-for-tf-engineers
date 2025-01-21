
variable "cluster_type" {
  description = "The type of cluster to deploy (kind or k3d)."
  type        = string
  default     = "kind"
}

variable "cluster_name" {
  description = "The name of the cluster to create."
  type        = string
}

variable "cluster_config_path" {
  description = "values for the cluster configuration file"
  type        = string
  default     = "~/.kube/"
}

variable "domain" {
  description = "The domain to use for the cluster."
  type        = string
  default     = "localhost"
}
