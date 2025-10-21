# Reusable GitHub Workflows Library

This repository contains reusable GitHub Actions workflows that can be called from other repositories using the `workflow_call` trigger.

## 🧩 Workflows

### 🟦 Teams Notification Template

**File:** `.github/workflows/teams-notification.yml`  
**Description:** Sends a Microsoft Teams notification when changes are detected in a repository.

#### Usage

In your target repository, create a workflow that calls this one:

```yaml
name: Notify Teams on Changes
on:
  push:
    branches: [ main ]

jobs:
  notify:
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/teams-notification.yml@main
    with:
      notification_title: '🚀 New Changes Detected'
      action_required_message: 'Please review new changes.'
    secrets:
      teams_webhook_url: ${{ secrets.TEAMS_WEBHOOK_URL }}
