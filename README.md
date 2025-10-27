# 🔄 Reusable GitHub Actions Workflows

This repository provides reusable GitHub Actions workflows for automating:
- ✅ Detecting file changes between release tags  
- ✅ Sending Microsoft Teams Adaptive Card notifications  

These workflows help engineering teams stay informed about critical changes and streamline release processes.

---

## 📦 Available Workflows

| Workflow | Description | Docs |
|-----------|--------------|------|
| [check-for-file-changes.yml](.github/workflows/check-for-file-changes.yml) | Detects if specified files changed between Git tags | – |
| [send-teams-notification.yml](.github/workflows/send-teams-notification.yml) | Sends customizable Microsoft Teams Adaptive Card notifications | [Setup Guide →](./docs/send-teams-notification.md) |

---

## ✅ Example Combined Usage
```yaml
name: Notify on App.java Changes

on:
  release:
    types: [published]
  workflow_dispatch:

permissions:
  contents: read

jobs:
  check_file_changes:
    uses: your-org/reusable-actions-library/.github/workflows/check-for-file-changes.yml@main
    with:
      watched_files: 'src/java/com/miha/app/App.java'

  send_teams_notification:
    needs: check_file_changes
    if: needs.check_file_changes.outputs.files_changed == 'true'
    uses: your-org/reusable-actions-library/.github/workflows/send-teams-notification.yml@main
    with:
      title: '🚀 App.java Changed in Release'
      message: '⚠️ **Action Required:** Prepare new installer for Template Designer'
      release_version: ${{ github.event.release.tag_name }}
      released_by: ${{ github.actor }}
      color: 'Warning'
      changed_files: ${{ needs.check_file_changes.outputs.changed_files_list }}
      link_url: ${{ github.event.release.html_url }}
      link_text: 'View Release'
    secrets:
      teams_webhook_url: ${{ secrets.TEAMS_WEBHOOK_INSTALLER_URL }}
