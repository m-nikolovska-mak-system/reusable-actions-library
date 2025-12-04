# 📢 Reusable Teams Notifier Template

A flexible GitHub Actions workflow that sends beautifully formatted Microsoft Teams notifications when files change in your repository.

## ✨ Features

- 🎨 Customizable card title, message, and color
- 👤 Shows who made the change with their GitHub avatar
- 📝 Lists all changed files
- 🔗 Direct link to view the commit
- ⏰ Timestamp in your timezone
- ✅ Error handling with HTTP status checking

## 🚀 Quick Start

### 1. Add the Template to Your Repo

Save `teams-notify-template.yml` to `.github/workflows/` in your repository.

### 2. Get a Teams Webhook URL

#### Method 1: Incoming Webhook Connector (Classic)
1. Teams channel → `⋯` → **Connectors**
2. Find **Incoming Webhook** → **Configure**
3. Copy the webhook URL

#### Method 2: Power Automate Workflow (New)
1. Teams channel → `⋯` → **Workflows**
2. Search "Post to a channel when a webhook request is received"
3. Set it up and copy the HTTP POST URL

Both work with this GitHub Action!
### 3. Create Your Notification Workflow

Create a new file like `.github/workflows/notify-my-changes.yml`:
```yaml
name: Notify My Changes

on:
  push:
    paths:
      - 'src/**'           # Watch your specific path
  workflow_dispatch:       # Allows manual trigger

jobs:
  notify:
    uses: ./.github/workflows/teams-notify-template.yml
    with:
      file_path: 'src/**'
      notification_title: '🚀 My Files Updated'
      action_required_message: '⚠️ **Action Required:** Please review the changes'
      card_color: 'Accent'
    secrets:
      teams_webhook_url: ${{ secrets.TEAMS_WEBHOOK_URL }}
```

That's it! Push a change and watch the magic happen ✨

## 🎨 Customization Options

### `notification_title`
The main heading of your Teams card.
- Example: `'🚀 Backend API Updated'`, `'📱 Mobile App Changed'`

### `action_required_message`
What should people do about this change?
- Example: `'⚠️ Please run tests'`, `'✨ FYI: Docs updated'`

### `card_color`
Visual theme of the card title:
- `'Accent'` - Blue (default)
- `'Good'` - Green (success)
- `'Warning'` - Orange (caution)
- `'Attention'` - Red (urgent)

### `file_path`
What files trigger this? (Uses GitHub path patterns)
- `'**/*.js'` - All JavaScript files
- `'src/backend/**'` - Everything in src/backend
- `'docs/**/*.md'` - All markdown in docs

## 📚 Examples

### Backend API Changes
```yaml
name: Backend API Notification

on:
  push:
    paths:
      - 'api/**'
      - 'backend/**'

jobs:
  notify:
    uses: ./.github/workflows/teams-notify-template.yml
    with:
      notification_title: '⚙️ Backend API Updated'
      action_required_message: '⚠️ **Action Required:** Run integration tests'
      card_color: 'Warning'
    secrets:
      teams_webhook_url: ${{ secrets.TEAMS_WEBHOOK_BACKEND }}
```

### Documentation Updates
```yaml
name: Docs Notification

on:
  push:
    paths:
      - '**/*.md'
      - 'docs/**'

jobs:
  notify:
    uses: ./.github/workflows/teams-notify-template.yml
    with:
      notification_title: '📖 Documentation Updated'
      action_required_message: '✨ **FYI:** Docs have been updated'
      card_color: 'Good'
    secrets:
      teams_webhook_url: ${{ secrets.TEAMS_WEBHOOK_DOCS }}
```

### Critical Production Files
```yaml
name: Production Alert

on:
  push:
    paths:
      - 'config/production.yml'
      - 'deployment/**'

jobs:
  notify:
    uses: ./.github/workflows/teams-notify-template.yml
    with:
      notification_title: '🚨 Production Config Changed'
      action_required_message: '🔴 **URGENT:** Review before deployment!'
      card_color: 'Attention'
    secrets:
      teams_webhook_url: ${{ secrets.TEAMS_WEBHOOK_ALERTS }}
```

## 🔧 Multiple Webhooks

You can send different notifications to different Teams channels:
```yaml
# Development channel
secrets:
  teams_webhook_url: ${{ secrets.TEAMS_WEBHOOK_DEV }}

# Production alerts channel
secrets:
  teams_webhook_url: ${{ secrets.TEAMS_WEBHOOK_PROD }}
```

Just create multiple secrets in your repo with different webhook URLs!

## 🐛 Troubleshooting

**"Invalid workflow file" error?**
- Make sure `teams-notify-template.yml` is in `.github/workflows/` (top level, no subfolders)

**Notification not sending?**
- Check your webhook URL is correct in Secrets
- Verify the `paths:` pattern matches your changed files
- Look at the workflow run logs for the HTTP status code

**Want to test without pushing?**
- Use `workflow_dispatch:` in your trigger (see examples above)
- Go to **Actions** tab → Select your workflow → **Run workflow**

## 📝 Requirements

- GitHub repository with Actions enabled
- Microsoft Teams with webhook permissions
- Files must be in `.github/workflows/` directory

## 🤝 Contributing

Feel free to customize this template for your needs! Common modifications:
- Add more fields to the Teams card
- Change the timezone in `TZ='Europe/Belgrade'`
- Add conditional logic for different file types
- Include build status or test results

## 📄 License

Free to use and modify for your projects!

---

**Questions?** Check the [GitHub Actions docs](https://docs.github.com/en/actions) or [Adaptive Cards schema](https://adaptivecards.io/explorer/)
