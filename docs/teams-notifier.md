
---

# ✅ **3. reusable-actions-library/docs/teams-notifier.md**

```md
# MS Teams Notification Workflow

Sends messages to a Teams webhook using rich Adaptive Cards.

Workflow file:  
`.github/workflows/teams-notifier.yml`

---

## 🚀 Features

- Customizable title, message, and color
- Optional file list display
- Includes workflow metadata (repo, tag, commit, user)
- Works with all callers via `workflow_call`

---

## 📥 Inputs

| Input | Required | Description |
|-------|----------|-------------|
| `notification_title` | ❌ | Title displayed at top of Teams card |
| `action_required_message` | ❌ | Description / main message |
| `files` | ❌ | List of files to show in the card |
| `card_color` | ❌ | Hex color or Teams semantic color (Accent, Good, Warning…) |

---

## 🔐 Required Secrets

| Secret | Description |
|--------|-------------|
| `teams_webhook_url` | Incoming Webhook URL from MS Teams |

---

## 📤 Outputs

This workflow does **not** expose outputs. It performs a notification action only.

---

## 📄 Example Usage

```yaml
jobs:
  notify:
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/teams-notifier.yml@v1
    with:
      notification_title: "🚨 File Change Detected"
      action_required_message: "Files were modified in this release."
      card_color: "Accent"
      files: ${{ needs.check_changes.outputs.changed_files_list }}
    secrets:
      teams_webhook_url: ${{ secrets.TEAMS_WEBHOOK_URL }}
