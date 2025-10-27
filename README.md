# 🔄 Reusable GitHub Actions Workflows

This repository provides **reusable GitHub Actions workflows** designed for release automation and change tracking.

These workflows are used to:
- ✅ Detect file changes between release tags
- ✅ Notify teams via **Microsoft Teams Adaptive Cards**
- ✅ Simplify and standardize release communication across projects

---

## 📦 Available Workflows

### 1. 🧩 **Check File Changes**
Detects whether specific files have changed between the latest and previous Git release tags.

### 2. 💬 **Send Teams Notification**
Sends a rich Microsoft Teams Adaptive Card with release details, changed files, and links to your release.

---

## ✅ 1. Check File Changes Workflow

### **Purpose**
Compare the current release tag against the previous tag to identify whether certain watched files have changed.

### **Key Features**
- Automatically determines the previous release tag.
- Falls back gracefully to the first commit if no previous tag exists.
- Produces outputs for use in downstream jobs or notifications.

### **Inputs**
| Name | Description | Required | Default |
|------|--------------|----------|----------|
| `watched_files` | Files to monitor (comma-separated or newline-separated list). | ✅ | — |
| `current_tag` | Current release tag (usually `github.event.release.tag_name`). | ❌ | Auto-detected |
| `previous_tag` | Previous release tag for comparison. | ❌ | Auto-detected |

### **Outputs**
| Name | Description |
|------|--------------|
| `files_changed` | `true` if any watched files have changed |
| `changed_files_list` | Comma-separated list of changed files |

---

### **📘 Example Usage**

This example workflow demonstrates how to:
1. Detect if `App.java` changed between releases.  
2. Print the results for debugging.  
3. Send a Teams notification if a change is detected.

```yaml
name: Notify on App.java Changes

on:
  release:
    types: [published]
  workflow_dispatch:

permissions:
  contents: read

jobs:
  # 🧩 1. Check for file changes
  check_file_changes:
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/check-for-file-changes.yml@main
    with:
      watched_files: 'oneProjectWed/src/java/com/miha/app/App.java'

  # 🧾 2. Debug job to print outputs
  debug_outputs:
    needs: check_file_changes
    runs-on: ubuntu-latest
    steps:
      - name: Print outputs
        run: |
          echo "Files changed: ${{ needs.check_file_changes.outputs.files_changed }}"
          echo "Changed files list: ${{ needs.check_file_changes.outputs.changed_files_list }}"

  # 💬 3. Notify Microsoft Teams
  send_teams_notification:
    needs: check_file_changes
    if: needs.check_file_changes.outputs.files_changed == 'true'
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/send-teams-notification.yml@main
    with:
      title: '🚀 App.java Changed in Release'
      message: |
        ⚠️ **Action Required:** Prepare a new installer for Template Designer
      release_version: ${{ github.event.release.tag_name || inputs.release_tag }}
      color: 'Warning'
      released_by: ${{ github.actor }}
      changed_files: ${{ needs.check_file_changes.outputs.changed_files_list }}
      link_url: ${{ 
        github.event.release.html_url || 
        (inputs.release_tag && format('https://github.com/{0}/releases/tag/{1}', github.repository, inputs.release_tag)) || 
        format('https://github.com/{0}/releases', github.repository)
      }}
      link_text: ${{ 
        github.event.release.html_url && 'View Release' || 
        inputs.release_tag && 'View Release' || 
        'View All Releases'
      }}
    secrets:
      teams_webhook_url: ${{ secrets.TEAMS_WEBHOOK_INSTALLER_URL }}
