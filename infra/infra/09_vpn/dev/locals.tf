locals {
  aws_account_id    = "027922993866"
  region            = "us-east-1"
  environment_short = "dev"
  organization      = "southernlights-tech"
  vpc_name          = "dev-vpc"

  tags = {
    Environment = local.environment_short
    Git         = "https://github.com/${local.organization}/infra/tree/main/infra/09_vpn/dev"
    ManagedBy   = "Terraform"
    Service     = local.organization
    Project     = "vpn-infrastructure"
    AccountId   = local.aws_account_id
  }
}
