# OneChart

OneChart is a generic Helm chart for your application deployments. It simplifies the creation of Kubernetes manifests by providing a standard set of parameters for common deployment patterns.

## Installation

Add the Onechart Helm repository:

```bash
helm repo add onechart https://chart.onechart.dev
```

Install the chart:

```bash
helm install my-release onechart/onechart \
  --set image.repository=nginx \
  --set image.tag=1.19.3
```

## Pod Disruption Budget (PDB)

OneChart supports configuring a Pod Disruption Budget to ensure high availability during voluntary disruptions.

### PDB Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `podDisruptionBudgetEnabled` | Enables the creation of a Pod Disruption Budget. | `true` |
| `podDisruptionBudgetMinAvailable` | The minimum number of pods that must be available. | `1` (if no other PDB value is set) |
| `podDisruptionBudgetMaxUnavailable` | The maximum number of pods that can be unavailable. | `nil` |

### Smart PDB Logic (HPA Awareness)

OneChart implements "Smart PDB" logic to prevent misconfigurations that could block cluster maintenance or cause application downtime.

1. **Minimum Replicas Check**: A PDB is only created if the effective minimum number of replicas is greater than 1.
2. **HPA Awareness**: If Horizontal Pod Autoscaling (HPA) is enabled, the logic uses `autoscaling.minReplicas` to determine the minimum number of pods. If HPA is not enabled, it uses the static `replicas` value.
3. **Default Safety**: If PDB is enabled but neither `podDisruptionBudgetMinAvailable` nor `podDisruptionBudgetMaxUnavailable` is specified, it defaults to `minAvailable: 1`.

This ensures that single-replica deployments do not get a PDB that would prevent them from being evicted (which would happen if `minAvailable: 1` was applied to a single pod).
