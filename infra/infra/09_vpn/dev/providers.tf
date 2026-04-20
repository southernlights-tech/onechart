provider "aws" {
  region = local.region

  assume_role {
    role_arn = "arn:aws:iam::${local.aws_account_id}:role/service-role/terraform-shared"
  }

  default_tags {
    tags = local.tags
  }
}
