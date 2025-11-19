# Microsoft Teams Notification Workflow

This reusable workflow sends richly formatted Adaptive Card messages to a Microsoft Teams channel.  
It is designed for multi-repository use and supports customizable content, metadata injection, and file lists.

Workflow file:  
`.github/workflows/teams-notifier.yml`

---

## 🚀 Features

- Fully customizable title, message, and card color  
- Optional file list display (auto-formatted as a bullet list)  
- Displays repository, branch, workflow, timestamp, and commit metadata  
- Optional actor display (user who triggered workflow)  
- Built-in validation for colors and webhook availability  
- Compatible with `workflow_call` from any repository

---

## 📥 Inputs

| Input | Required | Description |
|-------|----------|-------------|-------------------------------------------|
| `notification_title` | ❌ | Title displayed on the Teams card |
| `action_required_message` | ❌ | Main description message |
| `card_color` | ❌ | Teams color theme (`Accent`, `Good`, `Warning`, `Attention`) |
| `files` | ❌ | List of files (comma or newline separated) |
| `include_actor` | ❌ | Whether to include the triggering GitHub user |
| `custom_timezone` | ❌ | Used for timestamp (e.g. `Europe/London`) |

Default values ensure the workflow always works even when inputs are missing.

---

## 🔐 Required Secrets

| Secret | Description |
|--------|-------------|
| `teams_webhook_url` | Microsoft Teams "Incoming Webhook" URL |

This must be configured by the *caller workflow*, not in this repo.

---

## 📤 Outputs

This workflow intentionally **does not produce outputs** —  
its sole purpose is sending notifications.

---

## 📄 Example Usage

```yaml
jobs:
  notify:
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/teams-notifier.yml@v1
    with:
      notification_title: "🚨 File Change Detected"
      action_required_message: "Files were modified in this release."
      card_color: "Warning"
      files: ${{ needs.check_changes.outputs.changed_files_list }}
      include_actor: true
      custom_timezone: "Europe/London"
    secrets:
      teams_webhook_url: ${{ secrets.TEAMS_WEBHOOK_URL }}
