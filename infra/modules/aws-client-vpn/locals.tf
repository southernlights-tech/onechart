locals {
  tags = {
    Name        = var.name
    Environment = var.environment
    Service     = var.name
    Terraform   = "True"
    Managedby   = var.managedby
    Repository  = var.repository
  }
}