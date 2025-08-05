# Kong Plugins

Configure Kong plugins for your OneChart deployments

[← Back to Documentation](index.md)

## Kong Plugins Overview

OneChart supports configuring custom Kong plugins for your ingress when using Kong as your ingress controller. This feature allows you to add any Kong plugin with flexible configuration.

!!! info "Prerequisites"
    You need Kong Ingress Controller installed in your Kubernetes cluster to use Kong plugins.

### How It Works

1. **Plugin Creation:** Each enabled plugin creates a `KongPlugin` Kubernetes resource named `{release-name}-{plugin-name}`
2. **Ingress Integration:** All enabled plugins are automatically referenced in the ingress annotations via `konghq.com/plugins`
3. **Flexible Configuration:** The `config` section is passed directly to Kong, supporting any plugin-specific configuration

## Plugin Configuration

### Basic Structure

Configure Kong plugins in your `values.yaml`:

```yaml
kong:
  plugins:
    # Plugin name (can be any identifier)
    my-plugin:
      enabled: true
      plugin: response-transformer  # Kong plugin type
      config:
        # Plugin-specific configuration
        append:
          headers:
            - "X-Custom-Header:value"
```

### Configuration Options

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `enabled` | ✅ | boolean | Enable/disable the plugin |
| `plugin` | ✅ | string | Kong plugin type (e.g., rate-limiting, jwt) |
| `config` | ❌ | object | Plugin-specific configuration |
| `protocols` | ❌ | array | Protocols: http, https, grpc, grpcs, tcp, tls |
| `disabled` | ❌ | boolean | Disable the plugin |
| `labels` | ❌ | object | Additional Kubernetes labels |
| `annotations` | ❌ | object | Additional Kubernetes annotations |

## Plugin Examples

<div class="plugin-example">
<h5>🌐 CORS Headers</h5>

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
</div>

<div class="plugin-example">
<h5>🚦 Rate Limiting</h5>

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
</div>

<div class="plugin-example">
<h5>🔄 Request Transformation</h5>

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
</div>

<div class="plugin-example">
<h5>🔐 JWT Authentication</h5>

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
</div>

<div class="plugin-example">
<h5>📊 Prometheus Metrics</h5>

```yaml
kong:
  plugins:
    prometheus:
      enabled: true
      plugin: prometheus
      config:
        per_consumer: true
```
</div>

<div class="plugin-example">
<h5>🔒 IP Restriction</h5>

```yaml
kong:
  plugins:
    ip-restriction:
      enabled: true
      plugin: ip-restriction
      config:
        allow:
          - "192.168.1.0/24"
          - "10.0.0.0/8"
```
</div>

### Multiple Plugins Example

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

### Advanced Configuration

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

## Popular Kong Plugins Reference

<div class="grid">
  <div class="card">
    <h4>Authentication</h4>
    <ul>
      <li><code>jwt</code> - JWT authentication</li>
      <li><code>oauth2</code> - OAuth 2.0 authentication</li>
      <li><code>basic-auth</code> - Basic authentication</li>
      <li><code>key-auth</code> - API key authentication</li>
    </ul>
  </div>
  <div class="card">
    <h4>Security</h4>
    <ul>
      <li><code>rate-limiting</code> - Rate limiting</li>
      <li><code>ip-restriction</code> - IP allowlist/denylist</li>
      <li><code>cors</code> - CORS handling</li>
      <li><code>bot-detection</code> - Bot detection</li>
    </ul>
  </div>
  <div class="card">
    <h4>Traffic Control</h4>
    <ul>
      <li><code>request-transformer</code> - Transform requests</li>
      <li><code>response-transformer</code> - Transform responses</li>
      <li><code>proxy-cache</code> - Response caching</li>
      <li><code>canary</code> - Canary deployments</li>
    </ul>
  </div>
  <div class="card">
    <h4>Observability</h4>
    <ul>
      <li><code>prometheus</code> - Prometheus metrics</li>
      <li><code>file-log</code> - File logging</li>
      <li><code>http-log</code> - HTTP logging</li>
      <li><code>datadog</code> - Datadog integration</li>
    </ul>
  </div>
</div>

!!! warning "Note"
    Plugin availability depends on your Kong installation. Some plugins may require Kong Enterprise or additional configuration.