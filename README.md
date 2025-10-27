## Check File Changes Workflow

Detects if specific files changed between two Git tags (current release vs previous release).

### Features
- Auto-detects previous tag if not provided.
- Handles first release scenario.
- Outputs:
  - `files_changed`: `true` or `false`
  - `changed_files_list`: Comma-separated list of changed files.

### Inputs
| Name          | Description                              | Required | Default |
|---------------|------------------------------------------|----------|---------|
| `watched_files` | Files to watch (comma or newline separated) | ✅ | — |
| `current_tag` | Current release tag                     | ❌ | `github.event.release.tag_name` |
| `previous_tag`| Previous tag to compare against         | ❌ | Auto-detected |

### Outputs
| Name                | Description                              |
|---------------------|------------------------------------------|
| `files_changed`     | `true` if any watched files changed     |
| `changed_files_list`| Comma-separated list of changed files   |

### Example Usage
```yaml
jobs:
  check_file_changes:
    uses: your-org/reusable-actions-library/.github/workflows/check-file-changes.yml@main
    with:
      watched_files: 'src/java/com/miha/app/App.java'
      current_tag: ${{ github.event.release.tag_name }}
