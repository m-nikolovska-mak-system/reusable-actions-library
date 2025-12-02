# 📘 Sync Docs to Confluence — GitHub Workflow

File: [.github/workflows/sync-docs-to-confluence.yml](https://github.com/m-nikolovska-mak-system/reusable-actions-library/blob/main/.github/workflows/sync-docs-to-confluence.yml)

Automates publishing Markdown files from the docs/ folder into Confluence, with safety checks, rename detection, and concurrency-protected updates.


---

## 🎯 What This Does

This workflow keeps your Confluence space in sync with your repository docs. It:

* Detects real content changes inside `docs/**`
* Warns when files were renamed/moved (to prevent duplicate pages)
* Publishes Markdown files as Confluence pages
* Organizes pages using folder structure → parent/child pages
* Prevents version-conflict errors using a concurrency lock
* Notifies on success or failure

**What you give it:**

* A `docs/` directory with Markdown files
* Confluence credentials (user + API token)
* Confluence space key and parent page ID

**What you get back:**

* ✅ Updated Confluence pages matching your repository structure
* 📂 Automatically mirrored folder hierarchy
* 🔔 Clear status output in the Actions logs

---

## 🚀 When It Runs

Triggered on:

* Any push to `main`
* Only when changes are detected inside `docs/**`

---

## 📥 Inputs (What You Customize)

| Input                 | Type   | Required? | What It Does                                                         | Example                              |
| --------------------- | ------ | --------- | -------------------------------------------------------------------- | ------------------------------------ |
| `folder`              | string | YES       | Root local folder containing your docs                               | `docs`                               |
| `confluence-base-url` | string | YES       | Base URL of your Confluence instance                                 | `https://company.atlassian.net/wiki` |
| `space-key`           | string | YES       | Confluence space key where pages will be published                   | `DS`                                 |
| `parent-page-id`      | string | YES       | ID of the parent/root page under which everything is created/updated | `2785550`                            |

---

## 🔐 Secrets (Required)

| Secret                 | What It Is                                    |
| ---------------------- | --------------------------------------------- |
| `CONFLUENCE_USER`      | Confluence user email                         |
| `CONFLUENCE_API_TOKEN` | Confluence API token generated from Atlassian |

---

## 📦 Action Used

This workflow uses:

```
Bhacaz/docs-as-code-confluence@v3
```

This handles uploading Markdown to Confluence via REST API and creating/updating pages.

---

## 🧠 Behavior Summary

### ✔ Detects Real Changes

Only runs the sync if *actual* differences exist inside `/docs`.

### ✔ Identifies Renamed Files

Warns if files were renamed or moved because Confluence might create duplicates.

### ✔ Protects Against Version Conflicts

Concurrency ensures only one run updates Confluence at a time.

### ✔ Auto-Creates Parent/Child Pages

Folder structure:

```
docs/
  API/
    v1.md
    v2.md
  Guides/
    intro.md
```

Becomes structured Confluence pages:

* DS › API

  * v1
  * v2
* DS › Guides

  * intro

---

## 💡 Usage Example

This is exactly how the workflow is expected to be used:

```yaml
name: Sync Docs to Confluence

on:
  push:
    branches:
      - main
    paths:
      - 'docs/**'

jobs:
  sync-docs:
    runs-on: ubuntu-latest

    concurrency:
      group: confluence-sync
      cancel-in-progress: false

    permissions:
      contents: read

    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 2

      - name: Check for actual doc changes
        id: check_changes
        run: |
          if git diff --quiet HEAD^ HEAD -- docs/ 2>/dev/null; then
            echo "changed=false" >> $GITHUB_OUTPUT
          else
            echo "changed=true" >> $GITHUB_OUTPUT
          fi

      - name: Publish Docs to Confluence
        if: steps.check_changes.outputs.changed == 'true'
        uses: Bhacaz/docs-as-code-confluence@v3
        with:
          folder: docs
          username: ${{ secrets.CONFLUENCE_USER }}
          password: ${{ secrets.CONFLUENCE_API_TOKEN }}
          confluence-base-url: https://company.atlassian.net/wiki
          space-key: DS
          parent-page-id: 2785550
```

---

## ⚠️ Notes & Limitations

* Deprecation warnings (`Buffer()` etc.) come from the action’s internal code — safe to ignore.
* Renaming files may create duplicate Confluence pages unless manually cleaned up.
* Requires Confluence API tokens (basic auth).


