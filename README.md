# 🔄 Reusable GitHub Actions Workflows

This repository provides **reusable GitHub Actions workflows** for automating:

- ✅ Detecting file changes between release tags
- ✅ Sending rich Microsoft Teams notifications with release details

These workflows help teams stay informed about critical changes and streamline release processes.

---

## 📦 Workflows Included

### 1. **Check File Changes**
Detects if specific files have changed between two Git tags (current release vs previous release).

### 2. **Send Teams Notification**
Sends a Microsoft Teams Adaptive Card notification with release details, changed files, and a link to the release.

---

## ✅ 1. Check File Changes Workflow

### **Purpose**
Compares the current release tag against the previous tag and checks if specified files have changed.

### **Features**
- Auto-detects previous tag if not provided.
- Handles first release scenario by falling back to initial commit.
- Outputs:
  - `files_changed`: `true` or `false`
  - `changed_files_list`: Comma-separated list of changed files.

### **Inputs**
| Name           | Description                              | Required | Default |
|---------------|------------------------------------------|----------|---------|
| `watched_files` | Files to watch (comma or newline separated) | ✅ | — |
| `current_tag` | Current release tag                     | ❌ | `github.event.release.tag_name` |
| `previous_tag`| Previous tag to compare against         | ❌ | Auto-detected |

### **Outputs**
| Name                | Description                              |
|---------------------|------------------------------------------|
| `files_changed`     | `true` if any watched files changed     |
| `changed_files_list`| Comma-separated list of changed files   |

### **Example Usage**
```yaml
jobs:
  check_file_changes:
    uses: your-org/reusable-actions-library/.github/workflows/check-file-changes.yml@main
    with:
      watched_files: 'src/java/com/miha/app/App.java'
      current_tag: ${{ github.event.release.tag_name }}
