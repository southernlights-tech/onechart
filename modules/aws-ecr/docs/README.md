# ECR Credentials Management

## Overview

ECR (Elastic Container Registry) authentication is handled automatically via a Kubernetes CronJob that refreshes credentials every 8 hours, ensuring continuous access to private container images.

## Architecture

### Components

- **CronJob**: `ecr-credential-helper` running in `kube-system` namespace
- **Container Image**: `amazon/aws-cli:2.15.17` (official AWS image)
- **Authentication**: EC2 instance IAM role with `ecr:GetAuthorizationToken` permission
- **Secret**: `ecr-registry-credentials` in `default` namespace (type: `kubernetes.io/dockerconfigjson`)

### How It Works

1. **CronJob runs every 8 hours** (ECR tokens expire after 12 hours)
2. **Retrieves ECR token** using `aws ecr get-login-password` (authenticated via IAM role)
3. **Creates/updates Kubernetes secret** with Docker registry credentials
4. **Pods reference secret** via `imagePullSecrets` to pull images from ECR

### Security Features

✅ **No static credentials** - Uses IAM role-based authentication  
✅ **Automatic token rotation** - Fresh tokens every 8 hours  
✅ **Audit trail** - All `ecr:GetAuthorizationToken` calls logged in CloudTrail  
✅ **Official AWS image** - Verified and maintained by AWS  
✅ **Least-privilege IAM** - Only `ecr:GetAuthorizationToken` and read access to specific repos

## Deployment

### Prerequisites

1. **Terraform infrastructure deployed** (includes IAM role with ECR permissions)
2. **K3s cluster running** and accessible via `kubectl`
3. **kubectl configured** to connect to the cluster

### Deploy the CronJob

```bash
# Apply the manifest
kubectl apply -f applications/07_k3s/dev/ecr-credential-helper.yaml

# Verify CronJob was created
kubectl get cronjob -n kube-system ecr-credential-helper

# Trigger initial run (don't wait for schedule)
kubectl create job -n kube-system --from=cronjob/ecr-credential-helper ecr-init

# Check job logs
kubectl logs -n kube-system job/ecr-init

# Verify secret was created
kubectl get secret ecr-registry-credentials -n default
```

### Expected Output

```
NAME                        TYPE                             DATA   AGE
ecr-registry-credentials    kubernetes.io/dockerconfigjson   1      30s
```

## Usage in Pods

### Method 1: Per-Pod imagePullSecrets

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-app
spec:
  imagePullSecrets:
  - name: ecr-registry-credentials
  containers:
  - name: app
    image: 027922993866.dkr.ecr.us-east-1.amazonaws.com/my-app:latest
```

### Method 2: ServiceAccount default (recommended for namespace)

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: default
  namespace: default
imagePullSecrets:
- name: ecr-registry-credentials
---
apiVersion: v1
kind: Pod
metadata:
  name: my-app
spec:
  serviceAccountName: default  # Will automatically use imagePullSecrets
  containers:
  - name: app
    image: 027922993866.dkr.ecr.us-east-1.amazonaws.com/my-app:latest
```

## Troubleshooting

### Check CronJob Status

```bash
# View CronJob details
kubectl describe cronjob -n kube-system ecr-credential-helper

# List recent jobs
kubectl get jobs -n kube-system | grep ecr

# Check last execution time
kubectl get cronjob -n kube-system ecr-credential-helper -o jsonpath='{.status.lastScheduleTime}'
```

### View Logs

```bash
# Get latest job name
JOB_NAME=$(kubectl get jobs -n kube-system -l app=ecr-credential-helper --sort-by=.metadata.creationTimestamp -o jsonpath='{.items[-1].metadata.name}')

# View logs
kubectl logs -n kube-system job/$JOB_NAME

# Follow logs for running job
kubectl logs -n kube-system job/$JOB_NAME -f
```

### Verify Secret Content

```bash
# Check secret exists
kubectl get secret ecr-registry-credentials -n default

# View secret details (metadata only)
kubectl describe secret ecr-registry-credentials -n default

# Decode and view dockerconfigjson (contains auth token)
kubectl get secret ecr-registry-credentials -n default -o jsonpath='{.data.\.dockerconfigjson}' | base64 -d | jq
```

### Manual Refresh

If you need to force a credential refresh immediately:

```bash
# Create a one-off job from the CronJob
kubectl create job -n kube-system --from=cronjob/ecr-credential-helper manual-refresh-$(date +%s)

# Watch the job
kubectl get jobs -n kube-system -w
```

### Common Issues

#### 1. Secret Not Created

**Symptoms**: Secret `ecr-registry-credentials` doesn't exist

**Check**:
```bash
# Check if CronJob exists
kubectl get cronjob -n kube-system ecr-credential-helper

# Check if any jobs ran
kubectl get jobs -n kube-system -l app=ecr-credential-helper

# Check job logs for errors
kubectl logs -n kube-system job/<job-name>
```

**Potential causes**:
- IAM role doesn't have `ecr:GetAuthorizationToken` permission
- AWS CLI can't access EC2 metadata (IMDSv2 issue)
- ServiceAccount missing RBAC permissions

#### 2. Image Pull Failures

**Symptoms**: `ErrImagePull` or `ImagePullBackOff` errors

**Check**:
```bash
# Describe the pod
kubectl describe pod <pod-name>

# Check if imagePullSecrets is set
kubectl get pod <pod-name> -o jsonpath='{.spec.imagePullSecrets}'

# Verify ECR repository exists
aws ecr describe-repositories --repository-names <repo-name>
```

**Potential causes**:
- Pod doesn't reference `imagePullSecrets`
- Secret expired (job failed to run)
- IAM role lacks permissions for specific ECR repo
- Image doesn't exist in ECR

#### 3. Permission Denied

**Symptoms**: Logs show `AccessDeniedException` or `UnauthorizedOperation`

**Check IAM role**:
```bash
# From Terraform outputs
cd infra/07_k3s/dev
terraform output role_arn

# Verify IAM policy is attached
aws iam list-attached-role-policies --role-name k3s-SSMRole
```

**Required permissions**:
- `ecr:GetAuthorizationToken` (for token retrieval)
- `ecr:BatchGetImage` (for pulling images)
- `ecr:GetDownloadUrlForLayer` (for pulling layers)

## Monitoring

### CloudWatch Logs (via CloudTrail)

All ECR token requests are logged:

```bash
# Search CloudTrail for ecr:GetAuthorizationToken events
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=GetAuthorizationToken \
  --max-results 10
```

### Kubernetes Events

```bash
# Watch CronJob events
kubectl get events -n kube-system --field-selector involvedObject.name=ecr-credential-helper -w

# Check for errors
kubectl get events -n kube-system --field-selector type=Warning
```

### Alerting Recommendations

Set up alerts for:
- CronJob failures (job status != Completed)
- Secret age > 12 hours (indicates refresh failure)
- Image pull failures in pods

## Maintenance

### Updating the CronJob

```bash
# Edit the manifest
vim applications/07_k3s/dev/ecr-credential-helper.yaml

# Apply changes
kubectl apply -f applications/07_k3s/dev/ecr-credential-helper.yaml

# Verify update
kubectl describe cronjob -n kube-system ecr-credential-helper
```

### Changing Refresh Frequency

Edit the `schedule` field in the CronJob spec:

```yaml
spec:
  schedule: "0 */6 * * *"  # Every 6 hours instead of 8
```

**Note**: ECR tokens expire after 12 hours, so refresh interval must be < 12 hours.

### Adding Namespaces

To create secrets in additional namespaces, modify the CronJob command:

```yaml
command:
- /bin/bash
- -c
- |
  set -euo pipefail
  
  NAMESPACES="default production staging"
  
  for NS in $NAMESPACES; do
    echo "[$(date)] Updating credentials in namespace: $NS"
    
    TOKEN=$(aws ecr get-login-password --region ${AWS_REGION})
    
    kubectl create secret docker-registry ecr-registry-credentials \
      --docker-server=${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com \
      --docker-username=AWS \
      --docker-password="${TOKEN}" \
      --namespace=$NS \
      --dry-run=client -o yaml | kubectl apply -f -
  done
```

## Security Considerations

### IAM Role Permissions

The EC2 instance IAM role has scoped permissions:

```json
{
  "Effect": "Allow",
  "Action": ["ecr:GetAuthorizationToken"],
  "Resource": "*"
},
{
  "Effect": "Allow",
  "Action": [
    "ecr:GetDownloadUrlForLayer",
    "ecr:BatchGetImage",
    "ecr:BatchCheckLayerAvailability"
  ],
  "Resource": ["arn:aws:ecr:us-east-1:027922993866:repository/*"]
}
```

### Secret Rotation

- Tokens refresh every 8 hours automatically
- Old tokens remain valid until 12-hour expiration
- No downtime during rotation

### Audit Trail

All credential requests are logged in AWS CloudTrail:
- Event: `GetAuthorizationToken`
- Service: `ecr.amazonaws.com`
- User: EC2 instance role

## Alternative Approaches (Not Used)

This implementation was chosen over:

1. **Manual binary upload** ❌ - Security hole (no authenticity verification)
2. **Kubelet credential provider** ⚠️ - More complex, requires binary management
3. **External Secrets Operator** ⚠️ - Over-engineering for single-node cluster
4. **Static credentials** ❌ - Security risk, requires manual rotation

## References

- [AWS ECR Authentication](https://docs.aws.amazon.com/AmazonECR/latest/userguide/registry_auth.html)
- [Kubernetes imagePullSecrets](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod)
- [Kubernetes CronJobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/)
