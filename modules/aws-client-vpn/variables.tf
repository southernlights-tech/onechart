variable "aws_account_id" {
  description = "AWS account ID for the VPN infrastructure"
  type        = string
}

variable "region" {
  description = "AWS region where the VPN endpoint will be deployed"
  type        = string
}

variable "name" {
  description = "Name prefix used for all VPN resources"
  type        = string
}

variable "environment" {
  description = "Environment name used for tagging and identification"
  type        = string
}

variable "environment_short" {
  description = "Short environment name used for resource naming and tagging"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC where the VPN endpoint will be deployed"
  type        = string
}

variable "client_cidr_block" {
  description = "CIDR block to be allocated for connected VPN clients"
  type        = string
}

variable "split_tunnel" {
  description = "Enable split tunneling"
  type        = bool
  default     = true
}

variable "session_timeout_hours" {
  description = "VPN session timeout in hours"
  type        = number
  default     = 12
}

variable "disconnect_on_session_timeout" {
  description = "Disconnect on session timeout"
  type        = bool
  default     = true
}

variable "vpn_port" {
  description = "VPN port"
  type        = number
  default     = 443
}

variable "self_service_portal" {
  description = "Enable self-service portal"
  type        = string
  default     = "enabled"
}

variable "dns_servers" {
  description = "List of DNS servers to be used by VPN clients for DNS resolution"
  type        = list(string)
}

variable "saml_provider_arn" {
  description = "ARN of the SAML identity provider used for federated authentication on the VPN endpoint"
  type        = string
}

variable "self_service_saml_provider_arn" {
  description = "ARN of the SAML identity provider used for the self-service portal"
  type        = string
}

variable "vpn_routes" {
  description = "List of VPN routes defining network destinations accessible through the VPN endpoint"
  type = list(object({
    cidr        = string
    description = string
  }))
}

variable "vpn_authorization_rules" {
  description = "VPN authorization rules based on groups"
  type = list(object({
    cidr        = string
    group       = string
    description = string
  }))
  default = []
}

variable "organization" {
  description = "Organization name to be included in the self-signed certificate"
  type        = string
}

variable "dns_names" {
  description = "List of DNS names to be included in the self-signed certificate"
  type        = list(string)
}

variable "log_retention_days" {
  description = "CloudWatch log retention period in days for VPN endpoint logs"
  type        = number
}

variable "availability_zones" {
  description = "List of availability zones in the region where VPN subnets will be deployed"
  type        = list(string)
}

variable "managedby" {
  description = "Email or team responsible for managing this VPN infrastructure"
  type        = string
}

variable "repository" {
  description = "Repository URL where this infrastructure code is managed"
  type        = string
}

