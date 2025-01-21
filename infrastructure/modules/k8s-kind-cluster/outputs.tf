output "cluster_config_path" {
  value = kind_cluster.this.kubeconfig_path
}

output "config" {
  value = kind_cluster.this
}
