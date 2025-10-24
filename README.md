# 🔁 Reusable Actions Library

A centralized library of reusable **GitHub Actions** and **composite steps** used across Mak System projects.

---

## 📦 Available Reusable Workflows

| Workflow | Description |
|-----------|--------------|
| **[release-file-watcher.yml](.github/workflows/release-file-watcher.yml)** | Detects file changes on release and sends a Teams notification |
| **[send-teams-notification.yml](.github/workflows/send-teams-notification.yml)** | Generic Teams Adaptive Card workflow for CI/CD alerts |

---

## 🧱 Composite Actions

| Action | Description |
|---------|--------------|
| **[check-file-changes](.github/actions/check-file-changes/action.yml)** | Detects changes between commits/tags |
| **[send-teams-message](.github/actions/send-teams-message/action.yml)** | Sends a formatted Adaptive Card message to Microsoft Teams |

---

## 🚀 Example Usage

```yaml
jobs:
  notify:
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/release-file-watcher.yml@main
    with:
      watched_file: 'src/java/com/miha/app/App.java'
      notification_title: '🚀 App.java Changed!'
      notification_message: '⚠️ Prepare new installer for Template Designer'
    secrets:
      teams_webhook_url: ${{ secrets.TEAMS_WEBHOOK_INSTALLER_URL }}
