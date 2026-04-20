resource "aws_iam_saml_provider" "vpn" {
  name                   = "aws-client-vpn-dev"
  saml_metadata_document = file("${path.module}/saml-metadata.xml")
}

module "vpn" {
  source = "../../../modules/aws-client-vpn"

  aws_account_id    = local.aws_account_id
  region            = local.region
  name              = "vpn"
  environment       = "development"
  environment_short = local.environment_short
  vpc_name          = local.vpc_name
  client_cidr_block = "10.100.0.0/22"

  saml_provider_arn              = aws_iam_saml_provider.vpn.arn
  self_service_saml_provider_arn = aws_iam_saml_provider.vpn.arn

  dns_servers = ["10.10.0.2"] # Default AWS DNS for 10.10.0.0/16 VPC

  vpn_routes = [
    {
      cidr        = "10.10.0.0/16"
      description = "VPC Dev Access"
    }
  ]

  organization       = local.organization
  dns_names          = ["vpn.dev.southernlights.tech"]
  log_retention_days = 7
  availability_zones = ["us-east-1a", "us-east-1b"]

  managedby  = "Terraform"
  repository = "https://github.com/southernlights-tech/infra"
}
