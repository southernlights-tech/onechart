# OneChart Documentation

<div class="hero">
  <h1>OneChart</h1>
  <p>One Helm Chart to Rule Them All</p>
</div>

## Overview

OneChart is a generic Helm chart for web applications. The idea is that most Kubernetes manifests look alike, only very few parts actually change.

<div class="highlight">
<strong>Why OneChart?</strong> Because no-one can remember the Kubernetes YAML syntax, and most applications have similar deployment patterns.
</div>

<div class="grid">
  <div class="card">
    <h4>🚀 Quick Deploy</h4>
    <p>Deploy any containerized application with minimal configuration</p>
  </div>
  <div class="card">
    <h4>🔧 Flexible</h4>
    <p>Supports ingress, secrets, volumes, probes, and more</p>
  </div>
  <div class="card">
    <h4>🔌 Kong Integration</h4>
    <p>Built-in support for Kong plugins and configurations</p>
  </div>
  <div class="card">
    <h4>📊 Production Ready</h4>
    <p>Includes HPA, PDB, monitoring, and security features</p>
  </div>
</div>

## Getting Started

### Installation

Add the OneChart Helm repository:

<div class="install-command">helm repo add onechart https://chart.onechart.dev</div>

### Quick Start

Deploy a simple nginx application:

```bash
helm template my-release onechart/onechart \
  --set image.repository=nginx \
  --set image.tag=1.19.3
```

### With Custom Configuration

Create a `values.yaml` file:

```yaml
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

Deploy with your configuration:

<div class="install-command">helm install my-release onechart/onechart -f values.yaml</div>

### Using OCI Repository

You can also use OneChart from an OCI repository:

```bash
helm install my-release oci://ghcr.io/gimlet-io/onechart --version 0.74.0 \
  --set image.repository=nginx \
  --set image.tag=1.19.3
```

## Configuration Reference

### Core Configuration

<div class="grid">
  <div class="card">
    <h4>Image Settings</h4>
    <pre><code>image:
  repository: nginx
  tag: "latest"
  pullPolicy: IfNotPresent</code></pre>
  </div>
  <div class="card">
    <h4>Environment Variables</h4>
    <pre><code>vars:
  DATABASE_URL: "postgres://..."
  API_KEY: "secret-key"</code></pre>
  </div>
  <div class="card">
    <h4>Resources</h4>
    <pre><code>resources:
  requests:
    cpu: "200m"
    memory: "200Mi"
  limits:
    memory: "200Mi"</code></pre>
  </div>
  <div class="card">
    <h4>Ingress</h4>
    <pre><code>ingress:
  host: app.example.com
  ingressClassName: nginx
  tlsEnabled: true</code></pre>
  </div>
</div>

### Advanced Features

<div class="grid">
  <div class="card">
    <h4>Health Probes</h4>
    <pre><code>probe:
  enabled: true
  type: "http"
  path: "/health"</code></pre>
  </div>
  <div class="card">
    <h4>Autoscaling</h4>
    <pre><code>autoscaling:
  minReplicas: 2
  maxReplicas: 50</code></pre>
  </div>
  <div class="card">
    <h4>Volumes</h4>
    <pre><code>volumes:
  - name: data
    path: /data
    size: 10Gi</code></pre>
  </div>
  <div class="card">
    <h4>Secrets</h4>
    <pre><code>secrets:
  secretManager:
    enabled: true</code></pre>
  </div>
</div>

## Kong Plugins

OneChart includes built-in support for Kong plugins when using Kong as your ingress controller.

<div class="highlight">
<strong>🔌 Flexible Plugin System:</strong> Configure any Kong plugin with custom settings, from CORS and rate limiting to JWT authentication and custom transformations.
</div>

### Quick Example

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
    
    rate-limit:
      enabled: true
      plugin: rate-limiting
      config:
        minute: 100
        policy: local
```

<div class="grid">
  <div class="card">
    <h4>🌐 CORS Support</h4>
    <p>Easy CORS configuration using response-transformer plugin</p>
  </div>
  <div class="card">
    <h4>🚦 Rate Limiting</h4>
    <p>Built-in rate limiting with flexible policies</p>
  </div>
  <div class="card">
    <h4>🔐 Authentication</h4>
    <p>JWT, OAuth2, API keys, and more</p>
  </div>
  <div class="card">
    <h4>🔄 Transformations</h4>
    <p>Request/response header and body transformations</p>
  </div>
</div>

[📖 View Complete Kong Plugins Documentation →](kong-plugins.md)

## Examples

### Simple Web Application

```yaml
image:
  repository: my-web-app
  tag: v1.0.0

vars:
  NODE_ENV: production
  PORT: "3000"

ingress:
  host: myapp.example.com
  ingressClassName: nginx
  tlsEnabled: true

resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 512Mi
```

### API with Database and Kong Plugins

```yaml
image:
  repository: my-api
  tag: v2.1.0

vars:
  DATABASE_URL: "postgres://user:pass@db:5432/mydb"
  REDIS_URL: "redis://redis:6379"

ingress:
  host: api.example.com
  ingressClassName: kong

kong:
  plugins:
    rate-limit:
      enabled: true
      plugin: rate-limiting
      config:
        minute: 1000
        hour: 10000
    
    jwt-auth:
      enabled: true
      plugin: jwt
      config:
        uri_param_names: ["token"]

probe:
  enabled: true
  path: "/health"

autoscaling:
  minReplicas: 3
  maxReplicas: 20
```

### Static Site with CDN

```yaml
image:
  repository: nginx
  tag: alpine

ingress:
  host: www.example.com
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "true"

resources:
  requests:
    cpu: 50m
    memory: 64Mi
  limits:
    cpu: 100m
    memory: 128Mi
```

## Complete Reference

### All Configuration Options

OneChart supports a wide range of Kubernetes features:

<div class="grid">
  <div class="card">
    <h4>🚀 Deployment</h4>
    <ul>
      <li>Image configuration</li>
      <li>Replica management</li>
      <li>Rolling updates</li>
      <li>Pod disruption budgets</li>
    </ul>
  </div>
  <div class="card">
    <h4>🌐 Networking</h4>
    <ul>
      <li>Services (ClusterIP, NodePort, LoadBalancer)</li>
      <li>Ingress with multiple controllers</li>
      <li>Network policies</li>
      <li>Port configurations</li>
    </ul>
  </div>
  <div class="card">
    <h4>🔒 Security</h4>
    <ul>
      <li>Secrets management</li>
      <li>Service accounts</li>
      <li>Security contexts</li>
      <li>Pod security policies</li>
    </ul>
  </div>
  <div class="card">
    <h4>📊 Observability</h4>
    <ul>
      <li>Health probes</li>
      <li>Prometheus monitoring</li>
      <li>Logging configuration</li>
      <li>Metrics collection</li>
    </ul>
  </div>
  <div class="card">
    <h4>💾 Storage</h4>
    <ul>
      <li>Persistent volumes</li>
      <li>ConfigMaps</li>
      <li>EmptyDir volumes</li>
      <li>Host path mounts</li>
    </ul>
  </div>
  <div class="card">
    <h4>⚡ Scaling</h4>
    <ul>
      <li>Horizontal Pod Autoscaler</li>
      <li>Resource requests/limits</li>
      <li>Node affinity</li>
      <li>Tolerations</li>
    </ul>
  </div>
</div>

<div class="highlight">
<strong>📚 Need more details?</strong> Check the <code>values.schema.json</code> file in the chart for complete configuration options and validation rules.
</div>