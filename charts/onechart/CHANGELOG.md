# Changelog

## 0.77.1
- **Fixed**: PodDisruptionBudget now correctly respects HPA minReplicas when autoscaling is enabled
- **Fixed**: PDB autoscaling detection now uses same logic as HPA (checks for cpuAverageUtilization/memoryAverageUtilization instead of autoscaling.enabled flag)
- **Updated**: Bumped common chart dependency to 0.9.0
- **Improved**: Added test coverage for PDB with HPA scenarios
- **Docs**: Fixed releaseNameOverride schema documentation

## 0.77.0 (breaking change)
- Removed deprecated/unimplemented configuration fields: `secretEnabled`, `secretName`, and `sealedSecrets`.
- Optimized internal secret management and template rendering logic.
