# Forked from [gimlet-io/onechart](https://github.com/gimlet-io/onechart)


# One chart to rule them all

A generic Helm chart for your application deployments.

Because no-one can remember the Kubernetes yaml syntax.

https://gimlet.io/docs/reference/onechart-reference


## Getting started

OneChart is a generic Helm Chart for web applications. The idea is that most Kubernetes manifest look alike, only very few parts actually change.

Add the Onechart Helm repository:

```bash
helm repo add onechart https://chart.onechart.dev
```

Set your image name and version, the boilerplate is generated.

```bash
helm template my-release onechart/onechart \
  --set image.repository=nginx \
  --set image.tag=1.19.3
```

The example below deploys your application image, sets environment variables and configures the Kubernetes Ingress domain name:

```bash
helm repo add onechart https://chart.onechart.dev
helm template my-release onechart/onechart -f values.yaml

# values.yaml
image:
  repository: my-app
  tag: fd803fc
vars:
  VAR_1: "value 1"
  VAR_2: "value 2"
ingress:
  annotations:
    kubernetes.io/ingress.class: nginx
  host: my-app.mycompany.com
```

### Alternative: using an OCI repository
You can also template and install onechart from an OCI repository as follows:

Check the generated Kubernetes yaml:

```bash
helm template my-release oci://ghcr.io/gimlet-io/onechart --version 0.62.0 \
  --set image.repository=nginx \
  --set image.tag=1.19.3
```

Deploy with Helm:

```bash
helm install my-release oci://ghcr.io/gimlet-io/onechart --version 0.62.0 \
  --set image.repository=nginx \
  --set image.tag=1.19.3
```

See all [Examples](/website/docs/examples/)

## Kong Plugins Configuration

OneChart supports configuring custom Kong plugins for your ingress when using Kong as your ingress controller. This feature allows you to add any Kong plugin with flexible configuration.

### Basic Usage

Configure Kong plugins in your `values.yaml`:

```yaml
kong:
  plugins:
    # Plugin name (can be any identifier)
    cors:
      enabled: true
      plugin: response-transformer  # Kong plugin type
      config:
        append:
          headers:
            - "access-control-allow-origin:https://example.com"
            - "access-control-allow-credentials:true"
```

### Supported Plugin Configuration

Each plugin supports the following configuration options:

- **enabled** (required): Boolean to enable/disable the plugin
- **plugin** (required): The Kong plugin type (e.g., `rate-limiting`, `response-transformer`, `jwt`)
- **config** (optional): Plugin-specific configuration object
- **protocols** (optional): Array of protocols (`http`, `https`, `grpc`, `grpcs`, `tcp`, `tls`)
- **disabled** (optional): Boolean to disable the plugin
- **labels** (optional): Additional Kubernetes labels for the plugin resource
- **annotations** (optional): Additional Kubernetes annotations for the plugin resource

### Common Plugin Examples

#### CORS Headers
```yaml
kong:
  plugins:
    cors:
      enabled: true
      plugin: response-transformer
      config:
        append:
          headers:
            - "access-control-allow-origin:https://myapp.com"
            - "access-control-allow-credentials:true"
            - "access-control-allow-methods:GET,POST,PUT,DELETE"
```

#### Rate Limiting
```yaml
kong:
  plugins:
    rate-limit:
      enabled: true
      plugin: rate-limiting
      config:
        minute: 100
        hour: 1000
        policy: local
```

#### Request Transformation
```yaml
kong:
  plugins:
    auth-headers:
      enabled: true
      plugin: request-transformer
      config:
        add:
          headers:
            - "X-API-Version:v1"
            - "X-Request-ID:${request_id}"
        remove:
          headers:
            - "X-Internal-Header"
```

#### JWT Authentication
```yaml
kong:
  plugins:
    jwt-auth:
      enabled: true
      plugin: jwt
      config:
        uri_param_names:
          - token
        cookie_names:
          - jwt
```

#### Multiple Plugins
```yaml
kong:
  plugins:
    cors:
      enabled: true
      plugin: response-transformer
      config:
        append:
          headers:
            - "access-control-allow-origin:*"
    
    rate-limit:
      enabled: true
      plugin: rate-limiting
      config:
        minute: 50
        policy: local
    
    request-id:
      enabled: true
      plugin: request-transformer
      config:
        add:
          headers:
            - "X-Request-ID:${request_id}"
```

### How It Works

1. **Plugin Creation**: Each enabled plugin creates a `KongPlugin` Kubernetes resource named `{release-name}-{plugin-name}`
2. **Ingress Integration**: All enabled plugins are automatically referenced in the ingress annotations via `konghq.com/plugins`
3. **Flexible Configuration**: The `config` section is passed directly to Kong, supporting any plugin-specific configuration

### Advanced Configuration

You can also specify additional metadata and protocols:

```yaml
kong:
  plugins:
    custom-plugin:
      enabled: true
      plugin: custom-transformer
      protocols: ["http", "https"]
      labels:
        environment: production
        team: backend
      annotations:
        description: "Custom transformation plugin"
      config:
        custom_field: "custom_value"
```

This Kong plugins system supports any official Kong plugin or custom plugins available in your Kong deployment.

## Contribution Guidelines

Thank you for your interest in contributing to the Gimlet project.

Below are some guidelines and best practices for contributing to this repository:

### Issues

If you are running a fork of OneChart and would like to upstream a feature, please open a pull request for it.

### New Features

If you are planning to add a new feature to OneChart, please open an issue for it first. Helm charts are prone to having too many features, and OneChart want to keep the supported use-cases in-check. Proposed features have to be generally applicable, targeting newcomers to the Kubernetes ecosystem.

### Pull Request Process

* Fork the repository.
* Create a new branch and make your changes.
* Open a pull request with detailed commit message and reference issue number if applicable.
* A maintainer will review your pull request, and help you throughout the process.

## Development

Development of OneChart does not differ from developing a regular Helm chart.

The source for OneChart is under `charts/onechart` where you can locate the `Chart.yaml`, `values.yaml` and the templates.

We write unit tests for our helm charts. Pull requests are only accepted with proper test coverage.

The tests are located under `charts/onechart/test` and use the https://github.com/helm-unittest/helm-unittest Helm plugin to run the tests.

For installation, refer to the CI workflow at `.github/workflows/build.yaml`.

## Release process

`make all` to test and package the Helm chart.
The chart archives are put under `docs/` together with the Helm repository manifest (index.yaml)
It is then served with Github Pages on https://chart.onechart.dev

Github Actions is used to automate the make calls on git tag events.
