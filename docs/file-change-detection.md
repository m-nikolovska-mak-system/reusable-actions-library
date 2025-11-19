# File Change Detection Workflow

This reusable workflow detects modified files between two Git tags (or releases).  
It is designed for automation pipelines that need to trigger conditional steps—such as notifications, deployments, or artifact generation—only when specific files have changed.

Workflow file:  
`.github/workflows/3check-file-changes.yml`

---

## 🚀 Features

- Compares **previous tag → current tag**
- Automatically detects the previous tag if not provided
- Fallback to first commit if this is the first release
- Detects changes for specific patterns (e.g., `src/**/*.java`)
- Provides machine-friendly outputs for downstream workflows
- Works with:
  - `release` events  
  - `workflow_call` via reusable workflows

> ⚠️ **Note:**  
> This workflow is not triggered directly.  
> It is designed to be **called from another workflow** using `workflow_call`.

---

## 📥 Inputs

| Input | Required | Description |
|-------|----------|-------------|
| `watched_files` | ✔️ | File patterns to track (comma or newline separated) |
| `current_tag` | ❌ | The tag used as the “head” of the comparison. Defaults to the release tag. |
| `previous_tag` | ❌ | The tag used as the “base”. Auto-detected when omitted. |
| `files_separator` | ❌ | Separator for output lists (default: `,`) |

---

## 📤 Outputs

| Output | Description |
|--------|-------------|
| `files_changed` | `"true"` if any watched files changed |
| `changed_files_list` | List of changed watched files |
| `all_changed_files` | All changed files between the two tags |
| `comparison_info` | Human-readable summary: `prevTag → currentTag` |

---

## 📄 Example Usage (Calling Workflow)

This is an example workflow in a consuming repository:

```yaml
name: Detect File Changes

on:
  release:
    types: [published]

jobs:
  check_changes:
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/3check-file-changes.yml@v1
    with:
      watched_files: |
        src/**/*.java
        config/**/*.xml
    secrets: inherit

  print_results:
    needs: check_changes
    runs-on: ubuntu-latest
    steps:
      - run: |
          echo "Files changed: ${{ needs.check_changes.outputs.files_changed }}"
          echo "List: ${{ needs.check_changes.outputs.changed_files_list }}"
          echo "Comparison: ${{ needs.check_changes.outputs.comparison_info }}"
