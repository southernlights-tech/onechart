# OneChart

A generic Helm chart for your application deployments.

[Changelog](CHANGELOG.md)

## Key Configurations

- **Image**: Define `image.repository` and `image.tag` to specify the container image.
- **Ingress**: Configure `ingress` to expose your application.
- **Resources**: Manage CPU and memory limits/requests under `resources`.
- **Environment Variables**: Use `vars` for simple environment variables.
- **Secrets & ConfigMaps**:
  - Use `existingConfigMaps` and `existingSecrets` to mount pre-existing resources.
  - Use `secrets.secretManager` for managing secrets from external providers (e.g., AWS Secrets Manager).

See `values.yaml` for a complete list of configurations.
