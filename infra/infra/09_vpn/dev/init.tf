terraform {
  backend "s3" {
    bucket       = "southernlights-tf-state-shared"
    encrypt      = true
    key          = "09_vpn/dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
