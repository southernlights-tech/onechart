# Terraform Module Template

This repository follows the official southernlights-tech Terraform Module standards. Use this template for any new infrastructure module extraction.

## Core File Structure

Ensure your repository contains the following structure at its root:

```text
├── examples/               # Usage examples
│   ├── minimal/            # Simplest usage
│   │   └── main.tf
│   └── complete/           # Advanced usage with all features
│       └── main.tf
├── .github/                # GitHub Actions CI workflows
│   └── workflows/
│       └── validate.yml
├── .gitignore              # Standard Terraform gitignore
├── LICENSE                 # Apache License 2.0
├── README.md               # Standardized documentation
├── main.tf                 # Core resource definitions
├── outputs.tf              # Structured outputs
├── variables.tf            # Input variable definitions
├── locals.tf               # Internal logic and tag merging
└── versions.tf             # Provider and TF version constraints
```

---

## README Template

Copy and adapt the following template for your new module's `README.md`.

# Terraform <Provider> <Name> Module

Terraform module to [describe what it does in 1-2 sentences].

## Features

- ✅ **[Feature 1]** - [Description]
- ✅ **[Feature 2]** - [Description]
- ✅ **Standardized Tagging** - Integration with southernlights-tech context.

## Quick Usage

### Minimal Example

```hcl
module "example" {
  source      = "github.com/southernlights-tech/terraform-aws-example"
  environment = "dev"
  name        = "example-resource"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `environment` | Environment name (dev, staging, prod) | `string` | - | yes |
| `name` | Resource name | `string` | - | yes |
| `tags` | Additional tags to apply | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `arn` | The Amazon Resource Name (ARN) of the resource. |
| `id` | The unique identifier of the resource. |

## Module Requirements

- **Terraform**: >= 1.0
- **AWS Provider**: >= 5.0

## License

Apache License 2.0 - See LICENSE file for details.
