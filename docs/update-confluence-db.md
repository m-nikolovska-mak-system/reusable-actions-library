# 📚 Update README Index in Confluence

**File:** [`.github/workflows/update-confluence-db.yml`](https://github.com/m-nikolovska-mak-system/reusable-actions-library/blob/main/.github/workflows/update-confluence-db.yml)

**Type:** Reusable Workflow (Called by other workflows)

**Purpose:** Scans all `docs/README-*.md` files, generates a documentation table, and updates a Confluence page with workflow info.

---

## 🎯 What This Does

This workflow automates your Confluence documentation by:

* Scanning `docs/README-*.md` files in your repository
* Extracting workflow name, last commit date, and commit message
* Building a sortable HTML table with links to README, workflow, and Git history
* Updating a Confluence page with the latest table and timestamp in CET

**What you give it:**

* Confluence page to update
* Optional custom README file pattern

**What you get back:**

* ✅ Updated Confluence page with workflow index
* ✅ HTML table of workflows, links, and last commit info

---

## 📥 Inputs (What You Customize)

| Input            | Type   | Default            | What It Does                      | Example                                |
| ---------------- | ------ | ------------------ | --------------------------------- | -------------------------------------- |
| `readme_pattern` | string | `docs/README-*.md` | Glob pattern to find README files | `docs/README-*.md`, `docs/manual-*.md` |

---

## 📤 Outputs (What You Get Back)

| Output         | What It Contains                                 | Example |
| -------------- | ------------------------------------------------ | ------- |
| `readme_count` | Total number of README files found and processed | `5`     |

---

## 💡 Usage Examples

### Example 1: Manual Trigger

```yaml
jobs:
  update_docs:
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/update-confluence-db.yml@main
```

**What happens:**

* ✅ Scans all README files in `docs/`
* ✅ Generates HTML table
* ✅ Updates Confluence page with CET timestamp

---

### Example 2: Trigger with Custom README Pattern

```yaml
jobs:
  update_docs:
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/update-confluence-db.yml@main
    with:
      readme_pattern: "docs/manual-*.md"
```

**What happens:**

* ✅ Only README files matching `manual-*.md` are included

---

### Example 3: Calling From Another Workflow

```yaml
jobs:
  trigger-update:
    uses: ./.github/workflows/update-confluence-db.yml
    secrets: inherit
```

**What happens:**

* ✅ Workflow can be triggered by other workflows
* ✅ Inherits repository secrets automatically

---

## 🔍 What Happens Inside (Step-by-Step)

1. **Checkout repository** with full history (`fetch-depth: 0`)
2. **Scan README files** in the `docs/` folder
3. **Extract metadata**: workflow name, last commit date, last commit message
4. **Build HTML table** with links to README, workflow YAML, and Git history
5. **Fetch current Confluence page version** via REST API
6. **Update Confluence page** with table, total workflows count, and CET timestamp
7. **Log success or failure**

---

## ❌ Troubleshooting

### Problem: `cat: table.html: No such file or directory`

**Why it happens:**

* No README files match the pattern
* Workflow didn’t generate table.html

**How to fix:**

1. Verify README files exist in `docs/`
2. Check `readme_pattern` input matches file names
3. Ensure workflow runs after checkout step

---

### Problem: Confluence page not updating

**Why it happens:**

* Invalid `CONFLUENCE_PAGE_ID`
* API token lacks edit permissions
* Network or auth issue

**How to fix:**

1. Check `CONFLUENCE_USER` and `CONFLUENCE_API_TOKEN` secrets
2. Confirm `CONFLUENCE_PAGE_ID` is correct
3. Test API manually:

```bash
curl -u "$CONFLUENCE_USER:$CONFLUENCE_API_TOKEN" https://yourcompany.atlassian.net/wiki/rest/api/content/$CONFLUENCE_PAGE_ID
```

---

## 🎛️ Required Secrets and Variables

### Secrets

| Secret                 | Description                    |
| ---------------------- | ------------------------------ |
| `CONFLUENCE_USER`      | Your Confluence email/username |
| `CONFLUENCE_API_TOKEN` | API token with edit rights     |
| `CONFLUENCE_PAGE_ID`   | Target page ID in Confluence   |

### Repository Variables

| Variable          | Value                               | Purpose                           |
| ----------------- | ----------------------------------- | --------------------------------- |
| `CONFLUENCE_BASE` | `https://yourcompany.atlassian.net` | Base URL for your Confluence site |

---

## 🔗 Related Docs

* [Confluence REST API](https://developer.atlassian.com/cloud/confluence/rest/)
* [GitHub Actions: Reusable Workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)

---
