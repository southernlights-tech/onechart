# TLS resources with stable naming and lifecycle management
resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = 2048

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [algorithm, rsa_bits]
  }
}

resource "tls_self_signed_cert" "ca" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name  = "${var.name}-ca"
    organization = var.organization
  }

  dns_names = var.dns_names

  validity_period_hours = 87600
  is_ca_certificate     = true

  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "ca" {
  private_key      = tls_private_key.ca.private_key_pem
  certificate_body = tls_self_signed_cert.ca.cert_pem

  lifecycle {
    create_before_destroy = true
  }

  tags = local.tags
}

resource "tls_private_key" "server" {
  algorithm = "RSA"
  rsa_bits  = 2048

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [algorithm, rsa_bits]
  }
}

resource "tls_cert_request" "server" {
  private_key_pem = tls_private_key.server.private_key_pem

  subject {
    common_name  = "${var.name}-server"
    organization = var.organization
  }

  dns_names = var.dns_names
}

resource "tls_locally_signed_cert" "server" {
  cert_request_pem      = tls_cert_request.server.cert_request_pem
  ca_private_key_pem    = tls_private_key.ca.private_key_pem
  ca_cert_pem           = tls_self_signed_cert.ca.cert_pem
  validity_period_hours = 87600

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "server" {
  private_key       = tls_private_key.server.private_key_pem
  certificate_body  = tls_locally_signed_cert.server.cert_pem
  certificate_chain = tls_self_signed_cert.ca.cert_pem

  lifecycle {
    create_before_destroy = true
  }

  tags = local.tags
}

# Client certificate for authentication
resource "tls_private_key" "client" {
  algorithm = "RSA"
  rsa_bits  = 2048

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [algorithm, rsa_bits]
  }
}

resource "tls_cert_request" "client" {
  private_key_pem = tls_private_key.client.private_key_pem

  subject {
    common_name  = "${var.name}-client"
    organization = var.organization
  }

  dns_names = var.dns_names
}

resource "tls_locally_signed_cert" "client" {
  cert_request_pem      = tls_cert_request.client.cert_request_pem
  ca_private_key_pem    = tls_private_key.ca.private_key_pem
  ca_cert_pem           = tls_self_signed_cert.ca.cert_pem
  validity_period_hours = 87600

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth",
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "client" {
  private_key       = tls_private_key.client.private_key_pem
  certificate_body  = tls_locally_signed_cert.client.cert_pem
  certificate_chain = tls_self_signed_cert.ca.cert_pem

  lifecycle {
    create_before_destroy = true
  }

  tags = local.tags
}