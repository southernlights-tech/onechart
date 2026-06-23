# OneChart

OneChart is a generic, highly configurable Helm chart designed to standardize deployments across your Kubernetes clusters. Instead of maintaining dozens of near-identical charts, OneChart provides a single, robust interface for almost any application deployment, following industry best practices by default.

## Feature Highlights

- **Standard Deployment**: Streamlined configuration for replicas, resource limits/requests, and liveness/readiness/startup probes.
- **Networking**: 
    - Automatic `Service` creation with sticky session support.
    - Comprehensive `Ingress` support with TLS, annotations, and Nginx Basic Auth.
    - First-class support for Kong Plugins (Rate limiting, CORS, Request Transformer).
- **Scaling & Availability**:
    - **HPA**: Horizontal Pod Autoscaler integration for dynamic scaling based on CPU/Memory.
    - **Smart PDB**: Intelligent Pod Disruption Budget management that respects HPA settings and ensures cluster stability.
- **Security & Configuration**:
    - Manage environment variables via `vars`.
    - Native support for `Secrets`, `ConfigMaps`, and `SealedSecrets`.
    - Secure integration with external secret managers (AWS, GCP, Vault) via CSI `SecretProviderClass`.
- **Persistence**: Easy `PersistentVolumeClaim` (PVC) management for stateful workloads via the `volumes` configuration.
- **Observability**: Built-in Prometheus `ServiceMonitor` and `PrometheusRule` templates for unified monitoring.

## Installation

Add the OneChart Helm repository:

```bash
helm repo add onechart https://chart.onechart.dev
```

Install the chart:

```bash
helm install my-release onechart/onechart \
  --set image.repository=nginx \
  --set image.tag=1.21.0
```

## Core Concepts

### The "OneChart" Philosophy
The goal of OneChart is to provide a unified set of parameters that cover 90% of common deployment needs. By standardizing the interface, platform teams can ensure consistent security policies, observability, and operational standards across all teams without requiring every developer to become a Helm expert.

### Smart PDB Logic
OneChart implements "Smart PDB" logic to prevent misconfigurations that could block cluster maintenance or cause application downtime:

1. **Minimum Replicas Check**: A PDB is only created if the effective minimum number of replicas is greater than 1. This ensures that single-replica deployments do not get a PDB that would prevent them from being evicted (which would freeze node upgrades).
2. **HPA Awareness**: If Horizontal Pod Autoscaling (HPA) is enabled, the logic uses `autoscaling.minReplicas` to determine the minimum number of pods. If HPA is not enabled, it uses the static `replicas` value.
3. **Default Safety**: If PDB is enabled (`podDisruptionBudgetEnabled: true`) but neither `podDisruptionBudgetMinAvailable` nor `podDisruptionBudgetMaxUnavailable` is specified, it defaults to `minAvailable: 1`.

## Security & Hardening

OneChart is designed with security-first principles to ensure your applications run in a hardened environment by default.

### Default Security Context
By default, OneChart applies a restrictive `securityContext` to all pods:
- **`runAsNonRoot: true`**: The container is required to run as a non-root user. If the container image attempts to run as root, Kubernetes will fail to start it.
- **`readOnlyRootFilesystem: true`**: The container's root filesystem is mounted as read-only. This prevents attackers from modifying the application binaries or installing malicious tools if the container is compromised.

### Handling Write Requirements
If your application needs to write to specific directories (e.g., `/tmp`, `/app/cache`, or `/var/log`), the recommended approach is to mount an `emptyDir` volume at those locations. This maintains the security of the root filesystem while providing the necessary write access.

Example `values.yaml` configuration:
```yaml
volumes:
  - name: cache-volume
    mountPath: /app/cache
    emptyDir: {}
  - name: tmp-volume
    mountPath: /tmp
    emptyDir: {}
```

### Legacy Exceptions
While not recommended, some legacy applications may strictly require root access or a writable root filesystem. You can override the default security settings in your `values.yaml`:

```yaml
podSecurityContext:
  runAsNonRoot: false
  # You may also need to specify the user/group IDs
  # runAsUser: 0
  # runAsGroup: 0
securityContext:
  readOnlyRootFilesystem: false
```

## Configuration Reference

The following table lists the most commonly used configuration parameters.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Image repository | `nginx` |
| `image.tag` | Image tag | `latest` |
| `replicas` | Number of replicas (if HPA is disabled) | `1` |
| `vars` | Dictionary of environment variables | `{}` |
| `resources` | Pod resource requests and limits | `cpu: 200m, mem: 200Mi` |
| `ingress.host` | Ingress hostname | `nil` |
| `ingress.tlsEnabled` | Enable TLS for ingress | `false` |
| `podDisruptionBudgetEnabled` | Enable Smart PDB logic | `true` |
| `volumes` | List of volumes and mounts (supports PVC) | `[]` |
| `monitor.enabled` | Enable Prometheus ServiceMonitor | `false` |

## Examples

### Simple Nginx Deployment
```yaml
image:
  repository: nginx
  tag: 1.21.0
replicas: 3
containerPort: 8080
```

### Ingress with Basic Auth
```yaml
ingress:
  host: my-app.example.com
  ingressClassName: nginx
  tlsEnabled: true
  nginxBasicAuth:
    user: authorized-user
    password: changeme
```

### High Availability with HPA
```yaml
replicas: 2
autoscaling:
  minReplicas: 3
  maxReplicas: 10
  cpuAverageUtilization: 80
```

### AWS Secrets Manager Integration
```yaml
secrets:
  secretManager:
    name: "production/my-app"
    keys:
      - "DB_PASSWORD"
      - "API_KEY"
    keyMappings:
      DATABASE_URL_KEY: "DATABASE_URL"
```

---
For a full list of parameters, see the [values.yaml](./values.yaml) file or the [JSON Schema](./values.schema.json).
