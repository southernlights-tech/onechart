# Security Group
resource "aws_security_group" "vpn" {
  name_prefix = "${var.name}-vpn-"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
    # cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "${var.name}-vpn-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# VPN Endpoint - This is the main resource that was being recreated
resource "aws_ec2_client_vpn_endpoint" "main" {
  description                   = "${var.name} Client VPN"
  server_certificate_arn        = aws_acm_certificate.server.arn
  client_cidr_block             = var.client_cidr_block
  split_tunnel                  = var.split_tunnel
  vpc_id                        = data.aws_vpc.selected.id
  session_timeout_hours         = var.session_timeout_hours
  disconnect_on_session_timeout = var.disconnect_on_session_timeout
  security_group_ids            = [aws_security_group.vpn.id]
  vpn_port                      = var.vpn_port
  self_service_portal           = var.self_service_portal
  dns_servers                   = var.dns_servers
  # dns_servers = ["169.254.169.253"]

  authentication_options {
    type                           = "federated-authentication"
    saml_provider_arn              = var.saml_provider_arn
    self_service_saml_provider_arn = var.self_service_saml_provider_arn
    root_certificate_chain_arn     = aws_acm_certificate.client.arn
  }

  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = aws_cloudwatch_log_group.vpn.name
    cloudwatch_log_stream = aws_cloudwatch_log_stream.vpn.name
  }

  tags = merge(local.tags, {
    Name = "${var.name}-client-vpn"
  })

  # Prevent recreation by ensuring certificates are created first
  depends_on = [
    aws_acm_certificate.server,
    aws_acm_certificate.client,
    aws_cloudwatch_log_group.vpn,
    aws_cloudwatch_log_stream.vpn
  ]

  lifecycle {
    create_before_destroy = true
    # Ignore changes to certificate ARNs to prevent recreation
    ignore_changes = [
      server_certificate_arn,
      authentication_options
    ]
  }
}

# Network Association
resource "aws_ec2_client_vpn_network_association" "main" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.main.id
  subnet_id              = data.aws_subnets.selected.ids[0]

  lifecycle {
    create_before_destroy = true
  }
}

# Network Routes
resource "aws_ec2_client_vpn_route" "routes" {
  for_each = { for idx, route in var.vpn_routes : idx => route }

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.main.id
  destination_cidr_block = each.value.cidr
  target_vpc_subnet_id   = data.aws_subnets.selected.ids[0]
  description            = each.value.description
}

# Authorization rule to allow access to all networks
resource "aws_ec2_client_vpn_authorization_rule" "all_groups" {
  # Use this if vpn_authorization_rules is empty (default)
  count                  = length(var.vpn_authorization_rules) > 0 ? 0 : 1
  
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.main.id
  target_network_cidr    = "0.0.0.0/0"
  authorize_all_groups   = true
  description            = "Allow all authenticated users access to all networks"
}

# Authorization rules based on groups
resource "aws_ec2_client_vpn_authorization_rule" "group_vpn_authorization" {
  for_each = { for idx, rule in var.vpn_authorization_rules : idx => rule }

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.main.id
  target_network_cidr    = each.value.cidr
  access_group_id        = each.value.group
  description            = each.value.description
}
