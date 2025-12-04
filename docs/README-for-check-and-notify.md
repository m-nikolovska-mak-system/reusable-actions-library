# Reusable Actions Library

This repository contains shared, versioned GitHub Actions workflows used across multiple projects.  
It provides reliable, centralized automation for:

- Detecting file changes between releases or tags
- Sending adaptive MS Teams notifications
- Standardized CI/CD patterns

All workflows follow GitHub’s `workflow_call` pattern and are designed to be consumed by any repository in the organization.

---

## 📦 Available Reusable Workflows

### 1. File Change Detection  
Located at:  
`.github/workflows/3check-file-changes.yml`  
Documentation:  
[docs/README-3check-file-changes.md](README-3check-file-changes.md)

### 2. MS Teams Notifier  
Located at:  
`.github/workflows/teams-notifier.yml`  
Documentation:  
[docs/README-teams-notifier.md](README-teams-notifier.md)

---

## 🧩 How to Use These Workflows

In a consuming repo:

```yaml
jobs:
  check_changes:
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/3check-file-changes.yml@v1
