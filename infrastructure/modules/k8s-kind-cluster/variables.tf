variable "cluster_name" {
  description = "The name of the cluster to create."
  type        = string
}

variable "cluster_config_path" {
  description = "values for the cluster configuration file"
  type        = string
  default     = "~/.kube/"
}
