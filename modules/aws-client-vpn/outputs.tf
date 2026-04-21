output "vpn_id" {
  value       = aws_ec2_client_vpn_endpoint.main.id
  description = "The ID of the Client VPN endpoint"
}

output "vpn_arn" {
  value       = aws_ec2_client_vpn_endpoint.main.arn
  description = "The ARN of the Client VPN endpoint"
}

output "vpn_dns_name" {
  value       = aws_ec2_client_vpn_endpoint.main.dns_name
  description = "VPN DNS name"
}

output "security_group_id" {
  value       = aws_security_group.vpn.id
  description = "The ID of the VPN security group"
}

output "client_certificate" {
  value       = tls_locally_signed_cert.client.cert_pem
  description = "Client certificate for VPN authentication"
  sensitive   = true
}

output "client_private_key" {
  value       = tls_private_key.client.private_key_pem
  description = "Client private key for VPN authentication"
  sensitive   = true
}

output "ca_certificate" {
  value       = tls_self_signed_cert.ca.cert_pem
  description = "CA certificate"
  sensitive   = true
}

output "self_service_portal_url" {
  value       = aws_ec2_client_vpn_endpoint.main.self_service_portal_url
  description = "The URL of the self-service portal for Client VPN"
}