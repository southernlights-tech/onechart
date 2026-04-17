Secure Development & Delivery Procedure (SDDP)

Version 1.0 — Initial proposal for team review

📌 Context

This document is designed for agile teams where collaboration is high and bureaucracy should be kept to a minimum. We seek balance between development velocity and the standards necessary to build secure and auditable software.

📌 Objective

Establish a simple, auditable, and automated procedure that allows us to:

- Maintain development agility and velocity
- Ensure code quality and security from day one
- Generate evidence for future certifications (SOC2 / ISO 27001) without extra work
- Scale processes as the team grows, without having to redo everything

📌 Scope

Applies to all repositories containing:

Source code

Docker containers and images

Infrastructure as Code (Terraform, Kustomize, Helm)

GitOps manifests managed by Flux

CI/CD pipelines

1. Branching and Work Strategy
1.1 Branch Structure

main

Protected branch.

Represents the "deployable" state and/or desired state for GitOps.

Only allows merge through approved PR with valid checks.

<ticket>/<type>-<description>

New features, fixes, or improvements.

Short-lived branches merged via PR.

Types (aligned with [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)):
- **feat**: New infrastructure capability or feature
- **fix**: Bug fix or configuration correction
- **docs**: Documentation, runbooks, disaster recovery plans
- **chore**: Maintenance tasks (dependency updates, version bumps)
- **refactor**: Code/IaC restructuring without functionality change
- **test**: Infrastructure tests (Terratest, K8s validation)
- **ci**: CI/CD pipeline changes (GitHub Actions)
- **perf**: Performance improvements or cost optimizations

Examples:
- `123/feat-vault-integration` - Add HashiCorp Vault for secrets management
- `456/fix-ingress-tls` - Fix TLS certificate configuration in ingress
- `789/docs-dr-runbook` - Add disaster recovery runbook
- `101/chore-upgrade-flux` - Upgrade Flux CD to latest version

hotfix/<ticket>-<description>

Critical production fixes requiring immediate deployment.

Requires special validation and post-deployment review.

**Why hotfix is separate:** Hotfixes bypass normal development cycles for urgent production issues. The distinct naming makes the urgency explicit in git history and triggers expedited review processes while still maintaining security validations.

Example: `hotfix/999-critical-cve-patch` - Emergency security patch

1.2 Commits

We use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) (feat:, fix:, chore:, etc.).

Messages should be descriptive and concise.

GPG signing of commits is recommended (will be required when we prepare for SOC2 audit).

1.3 Hotfix Process

Hotfixes are urgent changes that require immediate deployment to production. We understand that under pressure it's tempting to skip steps, but maintaining these minimums protects us:

Creation:

    Create from main as hotfix/<ticket>-<description>
    (hotfix/ is a special type outside conventional commits for critical production issues)

    Include reference to incident/ticket (helps with future context)

Validations:

    All security validations are mandatory (they protect us even under pressure)

    Pre-commit hooks must pass

    CI must run completely

    Requires 1 approval (an extra pair of eyes prevents errors under stress)

Merge and Learning:

    Merge to main following standard process

    Brief blameless post-mortem: what did we learn? how do we prevent it?

    Can be async (team chat/Linear/Notion) - the important thing is to capture the learning

2. Pre-commit Validations (Pre-commit Hooks)

2.1 Why they're useful

Pre-commit hooks are like a copilot that reviews your code before it leaves your machine. They help you:

- Detect problems early (before others see them in PR)
- Avoid accidental commits of secrets (seriously a lifesaver)
- Maintain format consistency (less bikeshedding in reviews)
- Reduce back-and-forth in PRs (more flow, less friction)

2.2 Configuration

Each repository should include `.pre-commit-config.yaml` with appropriate validations for the stack:

**Essential validations:**

    Format and linters per language (Black/Python, Prettier/JS, Go fmt, etc)

    YAML/JSON validation (avoids silly syntax errors)

    Secret detection with Gitleaks (this can save your job)

    For Terraform: `terraform fmt` and `terraform validate`

    For GitOps: `kustomize build` (validates manifests are correct)

    Block accidentally large files

**Optional validations (add as needed):**

    Basic SAST with Semgrep

    Trivy filesystem scan

**Important:** If a validation fails, the commit is blocked. This may seem annoying at first, but it saves you headaches later. If you really need to bypass (e.g., WIP commit), you can use `git commit --no-verify`, but use it with judgment.

**Note on Enforcement:** While pre-commit hooks significantly improve developer experience and catch issues early, there is no way to enforce that developers run them locally. Therefore, all validations present in pre-commit hooks MUST also be replicated in CI/CD pipelines to guarantee execution before merge to main. This "defense in depth" approach ensures compliance even if pre-commit hooks are bypassed with `--no-verify`.

3. AI-assisted Review (optional and recommended)

Before opening a PR, consider requesting an automatic analysis using AI tools. This doesn't replace human review, but can help you detect issues before consuming the team's time:

For AI-assisted code review and security analysis, refer to our [internal tooling repository](https://github.com/southernlights-tech/internal-tooling) for current recommended tools, configurations, and best practices.

Suggested prompt:

Analyze the infrastructure changes I am introducing in this branch against main. 
Identify security risks, misconfigurations, compliance gaps, bad practices, and 
potential improvements. Generate a pull request description summarizing the change.

Focus on: IAM policies and RBAC configurations, network segmentation and policies, 
secrets management (Vault/SOPS integration), infrastructure drift detection, 
blast radius analysis, security hardening (CIS benchmarks), backup and disaster 
recovery strategies, observability coverage (metrics, logs, traces), and compliance 
requirements (SOC2/ISO27001).

Considerations:

    Check that there are no secrets before sharing code with LLMs

    AI analysis is a complement, not a replacement for team review

    Especially useful when you're learning or working in new areas

4. Pull Requests (PRs)
4.1 Mandatory requirements for merge

A PR can only be merged to main if:

    Has at least 1 approval from any team member (except the author)

    All automated checks are green

    Doesn't introduce secrets

    Doesn't incorporate critical/high vulnerabilities without team approval

    Has passed local pre-commit hooks

Review culture:

In agile teams, reviews are opportunities for mutual learning, not gatekeeping:

    Simple changes (docs, minor configs): quick approval to maintain momentum

    Critical infrastructure changes: take the necessary time. If you have doubts, ask

    Security changes (IAM, secrets, policies): ideally someone with experience in the area should review it

    For the reviewer: verify logic, look for hardcoded secrets, validate that infra changes make sense. If something doesn't feel right, ask - better safe than sorry

    For the author: facilitate review with good context in the PR, clear commits, and be available for questions

4.2 PR Template

The repo should include:

.github/pull_request_template.md

With the following points:

    Description of the change

    Linked ticket

    Security risks or considerations

    Infrastructure impact

    Pre-commit validation confirmed

    Testing checklist

    Required approvals

5. Automated Validations in CI/CD

Each repository should have a standard pipeline with the following minimum stages:
5.1 Lint

    Formatting

    Linters

    YAML validation

    kustomize build in GitOps repos

5.2 Security

    Gitleaks (secret scanning)

    Semgrep (SAST) - OWASP Top 10 rules

    Trivy fs (dependencies + CVEs)

    Checkov/Tfsec (IaC scanning)

Severity classification and action:

| Severity | Action | Remediation SLA | Exception Requires |
|----------|--------|-----------------|-------------------|
| CRITICAL | ❌ Blocks merge | Immediate (< 24h) | Team consensus + document reason |
| HIGH     | ❌ Blocks merge | 7 days | Quick conversation + agreement from at least 2 people |
| MEDIUM   | ⚠️ Warning + create ticket | 30 days | Reviewer's judgment |
| LOW      | ℹ️ Informative + backlog | 90 days | Not required |

**Note on severities:** SLAs are guidelines, not punishments. If a CRITICAL CVE is a false positive or doesn't apply to our case, we can make an exception. The important thing is to document the reasoning.

CRITICAL/HIGH findings are notified to the team for shared awareness.

5.3 Build & Tests

    Terraform plan validation

    Infrastructure tests (Terratest, kitchen-terraform, InSpec)

    Kubernetes manifest validation (kustomize build, kubeval)

    Container image builds (if applicable)

5.4 Publishing (if applicable)

    Push images to private registry

    Sign with cosign (recommended, mandatory when we have more clients)

    SBOM generation (recommended for production)

    Image scanning with Trivy

If CI fails → merge is blocked.

5.5 Team Notifications

The following events generate notifications in the team channel:

    Secret detection (Gitleaks) → immediate alert

    CRITICAL vulnerabilities in dependencies or images → alert

    Changes in security policies (IAM, Network Policies, RBAC) → notification for awareness

    Build/deploy failure → notification

6. Merge to Main and Publishing
6.1 Conditions

Merge can only be performed if:

    All checks have been approved

    PR checklist is complete

    No critical or high vulnerabilities exist

    No secrets or insecure configurations

6.2 Publishing

    Applications → build + push + SemVer tag

    Infrastructure → Terraform plan/apply from pipeline

    GitOps → Flux automatically applies changes to corresponding clusters

6.3 Rollback and Recovery

When something goes wrong in production, the priority is to restore the service. Learning comes after.

Rollback Process:

    Identification: Whoever detects the problem (monitoring, alerts, user) raises the alarm

    Decision and communication: 
        Alert the team in chat
        Don't wait for permissions - if you're sure a rollback is needed, do it
        If you have doubts, ask quickly (call/chat)

    Execution:
        For applications: Revert the commit in main → new automatic deploy
        For GitOps: Flux rollback or revert the manifest → automatic reconciliation
        For infrastructure: Terraform apply previous state

    Validation: Confirm the service returns to healthy state (don't declare victory prematurely)

    Blameless post-mortem: 
        What happened? How did we detect it? What can we improve?
        We're not looking for culprits, we're looking to learn
        Can be async (team chat/Linear/Notion) - the important thing is to capture the learning

**Target time:** < 15 minutes from decision to service restored.

**Note:** Rollbacks also go through CI, but if it's urgent we can merge without waiting for review. Priority is to restore the service.

7. Registry and Audit

For future audits (SOC2 / ISO 27001), we maintain automatic evidence:

    PR history with approvals

    CI/CD logs

    Terraform plan/apply logs

    GitOps manifests versioned in Git

    Security exception registry (when applicable)

All of this is already recorded in GitHub automatically.

7.1 Security Exception Process

Sometimes security tools block us for reasons that are valid for generic contexts, but don't apply to our specific situation. When this happens:

Exception process (agile but documented):

1. **Understand the finding:**
   - Is it really a problem in our context?
   - Is it a false positive?
   - Is a patch available or are we waiting for it to be released?

2. **Create ticket explaining:**
   - What vulnerability/finding we're excepting
   - Why it doesn't apply or why we need the exception
   - What mitigations we have (if applicable)
   - When we'll resolve it (if there's a date)

3. **Seek consensus:**
   - Share in team chat or discuss in quick call
   - For CRITICAL: minimum 2 people must agree
   - For HIGH: at least one other person should validate the reasoning
   - Document the decision in the ticket

4. **Implement and track:**
   - Add override in config (e.g., `.trivyignore`, `.semgrepignore`)
   - Comment with link to ticket (the "why" is important)
   - Create reminder to review
   - In monthly retros: review active exceptions

**Examples of valid exceptions:**
- Confirmed false positive after investigation
- CVE in functionality we don't use from a library
- Patch not available yet and we mitigate with compensating controls (WAF, network isolation)
- Transitive dependency that blocks upgrade, but we have a migration plan

**Reminder:** It's not "skipping" security, it's applying context. But always document the reasoning.

8. Continuous Improvement

This document is a living tool, not a bible carved in stone. As we learn and grow, the process should evolve:

Regular review:

    In monthly retros: what's slowing us down? what can we improve?

    When we onboard new people: is the process clear? where do they get stuck?

    When tools change: update examples and configs

    Before audits: formalize what we need to document better

This document is versioned like code: changes via PR → team review → merge.

8.1 Metrics (to improve and for future audits)

For agile workflows, we don't need complex dashboards initially. We can track basic metrics to understand how we're doing:

**Velocity metrics (DORA):**

    Deployment frequency: are we deploying frequently or accumulating changes?

    Lead time: how long does an idea take to reach production?

    Change failure rate: how many deploys end in rollback?

    MTTR: when something breaks, how long does it take us to fix it?

**Security metrics:**

    CRITICAL/HIGH vulnerabilities: found vs resolved (trend)

    Remediation time: are we improving?

    Detected secrets: should trend to 0

    Active exceptions: are we accumulating security debt?

**How to track them:**

- We don't need a fancy dashboard at first
- Review manually each month or quarter
- When we prepare for SOC2/ISO27001, we formalize with tools
- The important thing: use metrics to improve, not to punish

📌 Summary

This procedure is designed for agile teams:

    Formalizes good practices without adding unnecessary bureaucracy

    Automates security and quality validations (machines do the repetitive work)

    Maintains development velocity and agility

    Generates automatic evidence for future certifications (SOC2/ISO27001)

    Prioritizes consensus and collaboration over rigid hierarchies

    Scales gradually as the team grows

**Philosophy:**

Security and velocity are not opposites - they're complementary when done right. We automate what we can, review what's critical, and trust the team's judgment. Tools help us find problems, but people make decisions with context.

In agile teams, everyone is responsible. There's no separate "security team" - security is part of everyone's work, every day.

---

## Appendix A: Configuration Examples

**Note on Versions:** The dependency versions shown in these examples are current as of November 2024. Always verify and use the latest stable versions from official sources before implementing in production. For cloud-native tools, consult the [CNCF Landscape](https://landscape.cncf.io/) for graduated and incubating projects.

### A.1 .pre-commit-config.yaml file (minimal example)

```yaml
repos:
  # General validations
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-added-large-files
        args: ['--maxkb=500']
      - id: detect-private-key

  # Secret detection
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.29.0
    hooks:
      - id: gitleaks

  # Terraform
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.83.5
    hooks:
      - id: terraform_fmt
      - id: terraform_validate
      - id: terraform_tfsec

  # Python
  - repo: https://github.com/psf/black
    rev: 25.11.0
    hooks:
      - id: black

  # Optional SAST
  - repo: https://github.com/returntocorp/semgrep
    rev: v1.143.0
    hooks:
      - id: semgrep
        args: ['--config', 'auto', '--error']
```

### A.2 .github/pull_request_template.md file

```markdown
## What's changing and why

<!-- Brief description -->

## Type of Change

- [ ] Infrastructure (Terraform/NixOS)
- [ ] Kubernetes/GitOps (Flux manifests)
- [ ] Observability (OpenObserve/OTel)
- [ ] Security
- [ ] Urgent hotfix

## Ticket

Fixes #

## Checklist

- [ ] Pre-commit hooks passed
- [ ] Tested locally
- [ ] No hardcoded secrets
- [ ] If infra change: verified it makes sense

## Considerations

<!-- Anything important the reviewer should know? Requires additional changes (secrets, DNS, etc)? -->
```

### A.3 CODEOWNERS file (example)

```
# For agile teams - this is more for awareness than blocking
# Adjust with your team's GitHub usernames

# Critical infrastructure - someone from DevOps should review
/terraform/           @devops-team
/kubernetes/          @devops-team
/.github/workflows/   @devops-team

# If we have super critical paths (e.g., IAM, networking)
# /terraform/iam/     @all-devops-team
```

### A.4 CI/CD Pipeline (GitHub Actions example)

```yaml
name: Security & Quality Checks

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

jobs:
  security-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Gitleaks Secret Scanning
        uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Semgrep SAST
        uses: returntocorp/semgrep-action@v1
        with:
          config: auto
      
      - name: Trivy Scan
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          severity: 'CRITICAL,HIGH'
          exit-code: '1'
  
  terraform-validation:
    if: contains(github.event.pull_request.changed_files, 'terraform/')
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Terraform fmt
        run: terraform fmt -check -recursive
      
      - name: Terraform validate
        run: terraform validate
      
      - name: Checkov IaC Scan
        uses: bridgecrewio/checkov-action@master
        with:
          directory: terraform/
          framework: terraform
          soft_fail: false
  
  # Notify team if something critical fails
  # Integrate with your chat tool (generic webhooks work with most)
  notify-team:
    if: failure()
    needs: [security-scan]
    runs-on: ubuntu-latest
    steps:
      - name: Notify Team
        run: |
          echo "Security scan failed - configure notification per your chat tool"
          # Example with generic webhook:
          # curl -X POST ${{ secrets.WEBHOOK_URL }} \
          #   -H 'Content-Type: application/json' \
          #   -d '{"text":"Security scan failed on PR #${{ github.event.pull_request.number }}"}'
```

### A.5 Branch Protection Configuration (via GitHub Settings)

```json
{
  "required_status_checks": {
    "strict": true,
    "contexts": [
      "security-scan",
      "terraform-validation"
    ]
  },
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "dismiss_stale_reviews": false,
    "require_code_owner_reviews": false,
    "required_approving_review_count": 1
  },
  "restrictions": null,
  "require_linear_history": false,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "require_signed_commits": false
}
```

**Note:** `enforce_admins: false` allows us to bypass in emergencies if needed (but it's logged).

### A.6 Security Exception Template (GitHub Issue / Linear)

```markdown
## Security Exception

**CVE / Finding:** (e.g., CVE-2024-1234 or Semgrep rule XYZ)

**Severity:** CRITICAL / HIGH / MEDIUM

**Repo/PR:** 

## Why we need this exception

<!-- Is it a false positive? Doesn't apply to our case? No fix available? -->

## What mitigations we have

- [ ] We don't use that vulnerable functionality
- [ ] It's protected by WAF/firewall
- [ ] It's in internal network without public access
- [ ] Other: _______

## When we'll resolve it

**Target date:** (e.g., when patch comes out, in 2 weeks, etc.)

## Approval

Discussed with: @person1 @person2
Decision: ✅ Approved / ❌ Rejected
```

---

## Appendix B: Responsibilities by Activity

In agile teams, responsibilities are shared. This table is a guide, not a straitjacket:

| Activity | Who | Notes |
|----------|-----|-------|
| Create branch and commits | Whoever makes the change | Everyone develops |
| Run pre-commit hooks | Whoever makes the change | Automatic (runs by itself) |
| Create PR | Whoever makes the change | Everyone |
| Review and approve normal PR | Any other team member | Minimum 1 approval - it's a mutual learning moment |
| Review critical infra PR | Someone with experience in the area | If you have doubts, ask - better safe than sorry |
| Approve HIGH/CRITICAL exception | Team consensus (minimum 2 people) | Discuss openly, document reasoning |
| Merge to main | Author or whoever approved | Flexibility based on context |
| Monitor alerts | Whoever is on-call / everyone | Rotate so everyone learns |
| Execute rollback | Whoever detects the problem | Don't wait for permissions - alert and act |
| Keep this doc updated | Everyone collaborates | Improve it together in retros |

**Principles:**

- In agile teams, everyone is responsible for everything
- Reviews are learning opportunities, not gatekeeping
- Collaboration trumps bureaucracy
- We trust each person's judgment, but validate critical decisions as a team
- If something isn't clear, ask - there are no silly questions

---

**End of document - Version 1.0**
