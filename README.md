# 🔧 Reusable GitHub Actions Library

A collection of battle-tested, reusable GitHub Actions workflows for the organization. These workflows are the building blocks for creating consistent CI/CD pipelines across all our repositories.

> **👥 For End Users:** Looking to use these workflows? Check out our [workflow templates](https://github.com/YOUR-ORG/.github/tree/main/workflow-templates) for ready-to-use examples!

## 📚 Available Workflows

### 1. Check for File Changes
**File:** `.github/workflows/check-for-file-changes.yml`

Detects if specific files or paths have changed in a commit or release.

**Inputs:**
| Input | Required | Type | Description |
|-------|----------|------|-------------|
| `watched_files` | ✅ Yes | string | File patterns to monitor (glob format) |

**Outputs:**
| Output | Type | Description |
|--------|------|-------------|
| `files_changed` | boolean | `'true'` if any watched files changed, `'false'` otherwise |
| `changed_files_list` | string | Comma-separated list of changed files |

**Example Usage:**
```yaml
jobs:
  check_changes:
    uses: YOUR-ORG/reusable-actions-library/.github/workflows/check-for-file-changes.yml@main
    with:
      watched_files: 'src/**/*.java'
```

---

### 2. Send Teams Notification
**File:** `.github/workflows/send-teams-notification.yml`

Sends beautifully formatted Microsoft Teams notifications with support for release info, changed files, and custom styling.

**Inputs:**
| Input | Required | Type | Default | Description |
|-------|----------|------|---------|-------------|
| `title` | ✅ Yes | string | - | Notification title |
| `message` | ✅ Yes | string | - | Notification message (supports markdown) |
| `release_version` | No | string | `''` | Release version or tag name |
| `released_by` | No | string | `''` | Who triggered the action |
| `color` | No | string | `'Attention'` | Card color: `Attention`, `Good`, `Warning`, `Default` |
| `changed_files` | No | string | `''` | Comma-separated list of changed files |
| `link_url` | No | string | `''` | URL to link to |
| `link_text` | No | string | `'View Release'` | Text for the link button |

**Secrets:**
| Secret | Required | Description |
|--------|----------|-------------|
| `teams_webhook_url` | ✅ Yes | Microsoft Teams incoming webhook URL |

**Example Usage:**
```yaml
jobs:
  notify:
    uses: YOUR-ORG/reusable-actions-library/.github/workflows/send-teams-notification.yml@main
    with:
      title: '🚀 Deployment Complete'
      message: 'Production deployment was successful!'
      color: 'Good'
      link_url: 'https://app.example.com'
      link_text: 'Open Application'
    secrets:
      teams_webhook_url: ${{ secrets.TEAMS_WEBHOOK_URL }}
```

---

## 🎯 Common Use Cases

### Use Case 1: Monitor Critical Files
Combine both workflows to get notified when important files change:

```yaml
name: Monitor Production Config

on:
  push:
    branches: [main]
    paths:
      - 'config/production.yml'

jobs:
  check_changes:
    uses: YOUR-ORG/reusable-actions-library/.github/workflows/check-for-file-changes.yml@main
    with:
      watched_files: 'config/production.yml'
  
  notify:
    needs: check_changes
    if: needs.check_changes.outputs.files_changed == 'true'
    uses: YOUR-ORG/reusable-actions-library/.github/workflows/send-teams-notification.yml@main
    with:
      title: '🚨 Production Config Changed'
      message: 'Review changes immediately!'
      color: 'Attention'
      changed_files: ${{ needs.check_changes.outputs.changed_files_list }}
    secrets:
      teams_webhook_url: ${{ secrets.TEAMS_WEBHOOK_URL }}
```

### Use Case 2: Release Notifications
Send notifications when releases are published:

```yaml
name: Release Notification

on:
  release:
    types: [published]

jobs:
  notify:
    uses: YOUR-ORG/reusable-actions-library/.github/workflows/send-teams-notification.yml@main
    with:
      title: '🎉 New Release Published'
      message: 'A new version is now available!'
      release_version: ${{ github.event.release.tag_name }}
      released_by: ${{ github.actor }}
      color: 'Good'
      link_url: ${{ github.event.release.html_url }}
      link_text: 'View Release Notes'
    secrets:
      teams_webhook_url: ${{ secrets.TEAMS_WEBHOOK_URL }}
```

### Use Case 3: Build Status Notifications
Notify on build success or failure:

```yaml
name: Build and Notify

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run build
        run: ./build.sh
  
  notify_success:
    needs: build
    if: success()
    uses: YOUR-ORG/reusable-actions-library/.github/workflows/send-teams-notification.yml@main
    with:
      title: '✅ Build Successful'
      message: 'The build completed successfully on main branch'
      color: 'Good'
    secrets:
      teams_webhook_url: ${{ secrets.TEAMS_WEBHOOK_URL }}
  
  notify_failure:
    needs: build
    if: failure()
    uses: YOUR-ORG/reusable-actions-library/.github/workflows/send-teams-notification.yml@main
    with:
      title: '❌ Build Failed'
      message: 'The build failed on main branch. Please investigate.'
      color: 'Attention'
    secrets:
      teams_webhook_url: ${{ secrets.TEAMS_WEBHOOK_URL }}
```

---

## 🏗️ Architecture & Best Practices

### Versioning Strategy
We use branch-based versioning:

- **`@main`** - Latest stable version (recommended for most users)
- **`@v1`** - Major version branch (stable, receives bug fixes)
- **`@v1.2.3`** - Specific version tags (for absolute stability)

**Recommended:** Use `@main` for automatic updates with stability:
```yaml
uses: YOUR-ORG/reusable-actions-library/.github/workflows/send-teams-notification.yml@main
```

**For production-critical workflows:** Pin to a specific version:
```yaml
uses: YOUR-ORG/reusable-actions-library/.github/workflows/send-teams-notification.yml@v1.0.0
```

### Security Best Practices

1. **Always use secrets for sensitive data:**
   ```yaml
   secrets:
     teams_webhook_url: ${{ secrets.TEAMS_WEBHOOK_URL }}
   ```

2. **Restrict workflow permissions:**
   ```yaml
   permissions:
     contents: read  # Only what you need
   ```

3. **Validate inputs in your calling workflows**

### Error Handling

All workflows include built-in error handling and validation:
- ✅ Input validation with clear error messages
- ✅ HTTP status code checking
- ✅ Graceful failure with detailed logs

Check the workflow run logs in the Actions tab if something fails.

---

## 🔄 Contributing to This Library

### Adding a New Workflow

1. **Create the workflow file** in `.github/workflows/`
2. **Use consistent naming:** `verb-noun.yml` (e.g., `deploy-application.yml`)
3. **Start with the template:**

```yaml
name: Your Workflow Name

on:
  workflow_call:
    inputs:
      your_input:
        description: 'Clear description'
        required: true
        type: string
    secrets:
      your_secret:
        description: 'Clear description'
        required: true

jobs:
  your_job:
    runs-on: ubuntu-latest
    steps:
      - name: Validate inputs
        run: |
          if [ -z "${{ inputs.your_input }}" ]; then
            echo "❌ ERROR: your_input is required"
            exit 1
          fi
      
      # Your workflow steps here
```

4. **Add comprehensive documentation** (see below)
5. **Test thoroughly** before releasing
6. **Create a workflow template** in the `.github` repo

### Documentation Requirements

Every workflow MUST include:
- Clear description of purpose
- Complete inputs/outputs/secrets table
- At least 2 usage examples
- Common use cases
- Error handling explanation

### Testing Your Changes

1. Create a test repository
2. Call your workflow from the test repo
3. Test all input combinations
4. Test error cases (missing secrets, invalid inputs, etc.)
5. Verify error messages are helpful

---

## 📖 Additional Resources

### For Workflow Users
- 📝 [Workflow Templates](https://github.com/YOUR-ORG/.github/tree/main/workflow-templates) - Ready-to-use examples
- 🎓 [GitHub Actions Documentation](https://docs.github.com/en/actions)
- 💬 **Need help?** Open an issue or contact the DevOps team

### For Contributors
- 🔧 [Reusing Workflows (GitHub Docs)](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
- 🎨 [Creating Workflow Templates](https://docs.github.com/en/actions/using-workflows/creating-starter-workflows-for-your-organization)
- 🔒 [Security Hardening Guide](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)

---

**Current Status:** 🟢 Active Development
