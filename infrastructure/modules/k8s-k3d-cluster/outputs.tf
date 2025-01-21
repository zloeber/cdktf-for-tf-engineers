output "config" {
  value = k3d_cluster.this
}

output "credentials" {
  value     = k3d_cluster.this.credentials
  sensitive = true
}
