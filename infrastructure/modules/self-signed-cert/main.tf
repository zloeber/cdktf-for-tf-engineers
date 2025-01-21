variable "name" {
  type        = string
  description = "Common name for the certificate (e.g., 'git-server')"
}

variable "organization_name" {
  type        = string
  description = "Organization name for the certificate (e.g., 'Example Inc.')"
  default = "development"
}

variable "root_path" {
  description = "The root path of the module"
  type        = string
  default = "./"
}


resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "this" {
  #key_algorithm   = tls_private_key.this.algorithm
  private_key_pem = tls_private_key.this.private_key_pem

  subject {
    common_name  = var.name
    organization =  var.organization_name
  }

  validity_period_hours = 8760 # 1 year

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

output "certificate_pem" {
  value     = tls_self_signed_cert.this.cert_pem
  sensitive = true
}

output "private_key_pem" {
  value     = tls_private_key.this.private_key_pem
  sensitive = true
}

output "public_key_path" {
  value = local_file.public_key.filename
}

output "private_key_path" {
  value = local_file.private_key.filename
}

resource "local_file" "private_key" {
  content  = tls_private_key.this.private_key_pem
  filename = "${var.root_path}${var.name}_id_rsa"
}

resource "local_file" "public_key" {
  content  = tls_private_key.this.public_key_openssh
  filename = "${var.root_path}${var.name}_id_rsa.pub"
}
