
# 📝 Create Jira Issue — Reusable Workflow

**File:** [`.github/workflows/create-jira-issue.yml`](https://github.com/m-nikolovska-mak-system/reusable-actions-library/blob/main/.github/workflows/create-jira-issue.yml) — Reusable workflow to create a Jira issue in a specified project with validation and outputs the issue key and URL


---

## 🎯 What This Does

Creates a Jira issue using the Jira REST API with full validation.

**What you give it:**
- Jira project key
- Issue summary
- (Optional) Description
- (Optional) Issue type (default: Task)

**What you get back:**
- ✅ Jira issue key (e.g., `ERP-123`)
- ✅ Direct URL to the created issue

---

## 📥 Inputs (What You Customize)

| Input        | Type   | Required? | Default | What It Does | Example |
|-------------|--------|-----------|---------|-------------|---------|
| `project_key` | string | ✅ **YES** | — | Jira project key | `ERP` |
| `issuetype`   | string | No | `Task` | Type of Jira issue | `Bug` |
| `summary`     | string | ✅ **YES** | — | Summary of the Jira issue | `Automated task` |
| `desc`        | string | No | `""` | Description text | `Triggered by GitHub Actions` |

---

## 📤 Outputs (What You Get Back)

| Output      | What It Contains | Example |
|-------------|------------------|---------|
| `issue_key` | Jira issue key | `ERP-123` |
| `issue_url` | Direct link to issue | `https://company.atlassian.net/browse/ERP-123` |

---

## 💡 Usage Examples

### Example 1: Basic Issue Creation
```yaml
jobs:
  create_issue:
    uses: reusable-actions-library/.github/workflows/create-jira-issue.yml@main
    with:
      project_key: ERP
      summary: "Automated task"
      desc: "Triggered by GitHub Actions"
    secrets:
      JIRA_EMAIL: ${{ secrets.JIRA_USER }}
      JIRA_API_TOKEN: ${{ secrets.JIRA_API_TOKEN }}
      JIRA_URL: ${{ secrets.JIRA_BASE_URL }}
