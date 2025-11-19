
---

# ✅ **2. reusable-actions-library/docs/file-change-detection.md**

```md
# File Change Detection Workflow

This workflow detects file modifications between two tags or releases.  
It uses `tj-actions/changed-files` for reliable diffing.

Workflow file:  
`.github/workflows/3check-file-changes.yml`

---

## 🚀 Features

- Detects changes between **current tag** and **previous tag**
- Auto-detects previous tag when not provided
- Supports glob patterns (`src/**/*.java`)
- Outputs machine-friendly and human-friendly lists
- Compatible with `release` and `workflow_dispatch` triggers

---

## 📥 Inputs

| Input | Required | Description |
|-------|----------|-------------|
| `watched_files` | ✔️ | File patterns to track (comma or newline separated) |
| `current_tag` | ❌ | Tag to compare as the "head"; auto-detected if empty |
| `previous_tag` | ❌ | Tag to compare as the "base"; auto-detected if empty |
| `files_separator` | ❌ | Separator for returned files list (default: `,`) |

---

## 📤 Outputs

| Output | Description |
|--------|-------------|
| `files_changed` | `"true"` if any watched files changed |
| `changed_files_list` | List of changed watched files |
| `all_changed_files` | All changed files in the release |
| `comparison_info` | Text summary: `prev → current` |

---

## 📄 Example Usage

```yaml
jobs:
  check_changes:
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/3check-file-changes.yml@v1
    with:
      watched_files: "src/**/*.java"
      current_tag: ${{ github.ref_name }}
