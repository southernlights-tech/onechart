<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.ca](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate.client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate.server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_cloudwatch_log_group.vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_stream.vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream) | resource |
| [aws_ec2_client_vpn_authorization_rule.all_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_authorization_rule) | resource |
| [aws_ec2_client_vpn_authorization_rule.group_vpn_authorization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_authorization_rule) | resource |
| [aws_ec2_client_vpn_endpoint.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_endpoint) | resource |
| [aws_ec2_client_vpn_network_association.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_network_association) | resource |
| [aws_ec2_client_vpn_route.routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_route) | resource |
| [aws_security_group.vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [tls_cert_request.client](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/cert_request) | resource |
| [tls_cert_request.server](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/cert_request) | resource |
| [tls_locally_signed_cert.client](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/locally_signed_cert) | resource |
| [tls_locally_signed_cert.server](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/locally_signed_cert) | resource |
| [tls_private_key.ca](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_private_key.client](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_private_key.server](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.ca](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |
| [aws_subnets.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones in the region where VPN subnets will be deployed | `list(string)` | n/a | yes |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS account ID for the VPN infrastructure | `string` | n/a | yes |
| <a name="input_client_cidr_block"></a> [client\_cidr\_block](#input\_client\_cidr\_block) | CIDR block to be allocated for connected VPN clients | `string` | n/a | yes |
| <a name="input_disconnect_on_session_timeout"></a> [disconnect\_on\_session\_timeout](#input\_disconnect\_on\_session\_timeout) | Disconnect on session timeout | `bool` | `true` | no |
| <a name="input_dns_names"></a> [dns\_names](#input\_dns\_names) | List of DNS names to be included in the self-signed certificate | `list(string)` | n/a | yes |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | List of DNS servers to be used by VPN clients for DNS resolution | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name used for tagging and identification | `string` | n/a | yes |
| <a name="input_environment_short"></a> [environment\_short](#input\_environment\_short) | Short environment name used for resource naming and tagging | `string` | n/a | yes |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CloudWatch log retention period in days for VPN endpoint logs | `number` | n/a | yes |
| <a name="input_managedby"></a> [managedby](#input\_managedby) | Email or team responsible for managing this VPN infrastructure | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name prefix used for all VPN resources | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization name to be included in the self-signed certificate | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region where the VPN endpoint will be deployed | `string` | n/a | yes |
| <a name="input_repository"></a> [repository](#input\_repository) | Repository URL where this infrastructure code is managed | `string` | n/a | yes |
| <a name="input_saml_provider_arn"></a> [saml\_provider\_arn](#input\_saml\_provider\_arn) | ARN of the SAML identity provider used for federated authentication on the VPN endpoint | `string` | n/a | yes |
| <a name="input_self_service_portal"></a> [self\_service\_portal](#input\_self\_service\_portal) | Enable self-service portal | `string` | `"enabled"` | no |
| <a name="input_self_service_saml_provider_arn"></a> [self\_service\_saml\_provider\_arn](#input\_self\_service\_saml\_provider\_arn) | ARN of the SAML identity provider used for the self-service portal | `string` | n/a | yes |
| <a name="input_session_timeout_hours"></a> [session\_timeout\_hours](#input\_session\_timeout\_hours) | VPN session timeout in hours | `number` | `12` | no |
| <a name="input_split_tunnel"></a> [split\_tunnel](#input\_split\_tunnel) | Enable split tunneling | `bool` | `true` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC where the VPN endpoint will be deployed | `string` | n/a | yes |
| <a name="input_vpn_authorization_rules"></a> [vpn\_authorization\_rules](#input\_vpn\_authorization\_rules) | VPN authorization rules based on groups | <pre>list(object({<br/>    cidr        = string<br/>    group       = string<br/>    description = string<br/>  }))</pre> | `[]` | no |
| <a name="input_vpn_port"></a> [vpn\_port](#input\_vpn\_port) | VPN port | `number` | `443` | no |
| <a name="input_vpn_routes"></a> [vpn\_routes](#input\_vpn\_routes) | List of VPN routes defining network destinations accessible through the VPN endpoint | <pre>list(object({<br/>    cidr        = string<br/>    description = string<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ca_certificate"></a> [ca\_certificate](#output\_ca\_certificate) | CA certificate |
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate) | Client certificate for VPN authentication |
| <a name="output_client_private_key"></a> [client\_private\_key](#output\_client\_private\_key) | Client private key for VPN authentication |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the VPN security group |
| <a name="output_self_service_portal_url"></a> [self\_service\_portal\_url](#output\_self\_service\_portal\_url) | The URL of the self-service portal for Client VPN |
| <a name="output_vpn_arn"></a> [vpn\_arn](#output\_vpn\_arn) | The ARN of the Client VPN endpoint |
| <a name="output_vpn_dns_name"></a> [vpn\_dns\_name](#output\_vpn\_dns\_name) | VPN DNS name |
| <a name="output_vpn_id"></a> [vpn\_id](#output\_vpn\_id) | The ID of the Client VPN endpoint |
<!-- END_TF_DOCS -->

## VPN Authorization Rules Configuration

VPN authorization rules control which groups of users can access specific network CIDRs through the Client VPN endpoint. The `vpn_authorization_rules` variable accepts a list of authorization rules, each specifying a target CIDR, a description, and an associated group.

### Access Group IDs

Access group IDs are obtained from AWS IAM Identity Center, not from Okta. When using AWS IAM Identity Center for authentication, groups are managed within the AWS console, not in Okta. To find your group names:

1. Navigate to AWS Console → Search "IAM Identity Center"
2. Go to Groups
3. View the available groups (e.g., "aws-Users", "aws-Reviewers", "aws-Admins")
4. Click on a group → General Information
5. Use these exact group id as the `group` value in your authorization rules
6. Verify that your users are assigned to these groups in AWS IAM Identity Center

Note: Group membership is managed in AWS IAM Identity Center. When users authenticate through Okta, AWS IAM Identity Center assigns them to groups, and these groups are included in the SAML assertion sent to the VPN endpoint.
### Authorization Rule Behavior

The module implements a conditional authorization strategy based on the `vpn_authorization_rules` variable:

- **When `vpn_authorization_rules` is empty (default)**: The `aws_ec2_client_vpn_authorization_rule.all_groups` resource is created with `authorize_all_groups = true`. This grants all authenticated users access to all networks (0.0.0.0/0), regardless of group membership.

- **When `vpn_authorization_rules` contains one or more rules**: The `aws_ec2_client_vpn_authorization_rule.all_groups` resource is NOT created (count = 0). Instead, individual authorization rules are created via `aws_ec2_client_vpn_authorization_rule.group_vpn_authorization` using a `for_each` loop. Each rule restricts access to specific network CIDRs based on the user's group membership. Only users belonging to the specified group can access the associated CIDR block.

This design allows you to start with permissive access (all groups) and progressively implement granular group-based access controls by populating the `vpn_authorization_rules` variable.
