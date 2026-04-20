# Terraform Module Extraction Guidelines

This document outlines the process and standards for extracting Terraform logic into standalone, reusable modules within the southernlights-tech ecosystem. These guidelines are based on the successful extraction of the `terraform-aws-kms-sops` module.

## 1. Process Overview

When a piece of infrastructure logic (like KMS, VPC, or ECR) is identified as reusable across different environments or projects, it should be extracted into its own repository.

1. **Identification**: Identify redundant HCL code in the `infra/` directory.
2. **Standardization**: Generalize the code, replacing hardcoded values with variables.
3. **Extraction**: Create a new repository following the naming convention.
4. **Validation**: Implement examples and basic tests.
5. **Integration**: Reference the new module in the main `infra/` repository using Git sources.

## 2. Repository Naming Convention

All modules must follow the official Terraform provider-specific naming convention to ensure compatibility with the Terraform Registry and clear identification:

`terraform-<provider>-<name>`

Examples:
- `terraform-aws-kms-sops`
- `terraform-aws-ecr-repository`
- `terraform-google-gke-cluster`

## 3. Module Structure (Core Files)

Every module repository must contain the following core files at its root:

- `main.tf`: Primary resource definitions.
- `variables.tf`: Input variable definitions with descriptions and types.
- `outputs.tf`: Structured outputs.
- `versions.tf`: Required Terraform and provider versions.
- `locals.tf`: Internal logic, tag merging, and naming conventions.
- `README.md`: Documentation (see Template).
- `LICENSE`: Apache 2.0 or MIT.
- `examples/`: Directory containing `minimal/` and `complete/` usage examples.

## 4. Configuration Pattern (The "Context" Pattern)

To maintain consistency across southernlights-tech infrastructure, modules should support a "context" or standardized tagging pattern.

### Environment-Specifics in `locals.tf`
Use `locals.tf` to handle complex logic, such as merging default tags with user-provided tags:

```hcl
locals {
  module_tags = merge(
    var.tags,
    {
      Module    = "terraform-aws-kms-sops"
      ManagedBy = "Terraform"
    }
  )
}
```

## 5. CI/CD Integration

New module repositories should include GitHub Actions for automated validation:

- **Terraform Format Check**: `terraform fmt -check`
- **Terraform Validate**: `terraform validate`
- **Trivy/TFSec Scan**: For security vulnerabilities.
- **Documentation Update**: Automated README generation from variables (optional but recommended).

## 6. Integration in `infra/`

When using the module in the main infrastructure repository, always pin to a specific version or commit SHA for supply chain security:

```hcl
module "kms" {
  source = "git::https://github.com/southernlights-tech/terraform-aws-kms-sops.git?ref=v1.0.0"
  # ... inputs
}
```
