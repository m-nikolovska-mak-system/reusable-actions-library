Here are the **two short, user-focused README files** for your reusable workflows:

***

### ✅ `docs/create-jira-issue.md`

````markdown
# 📝 Create Jira Issue — Reusable Workflow

This workflow creates a Jira issue in a specified project with validation and outputs the issue key and URL.

**File:** `.github/workflows/create-jira-issue.yml`

---

## ⚙️ Usage

```yaml
jobs:
  create_issue:
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/create-jira-issue.yml@main
    with:
      project_key: "ERP"
      summary: "Automated task"
      desc: "Triggered by GitHub Actions"
    secrets:
      JIRA_EMAIL: ${{ secrets.JIRA_USER }}
      JIRA_API_TOKEN: ${{ secrets.JIRA_API_TOKEN }}
      JIRA_URL: ${{ secrets.JIRA_BASE_URL }}
````

***

## 📥 Inputs

| Input         | Required | Description                    |
| ------------- | -------- | ------------------------------ |
| `project_key` | ✔️       | Jira project key (e.g., `ERP`) |
| `issuetype`   | ❌        | Issue type (default: `Task`)   |
| `summary`     | ✔️       | Summary of the Jira issue      |
| `desc`        | ❌        | Description text               |

***

## 📤 Outputs

| Output      | Description                          |
| ----------- | ------------------------------------ |
| `issue_key` | Jira issue key (e.g., `ERP-123`)     |
| `issue_url` | Direct URL to the created Jira issue |

***

## 🔐 Required Secrets

| Secret           | Description                                               |
| ---------------- | --------------------------------------------------------- |
| `JIRA_EMAIL`     | Email of the Jira API user                                |
| `JIRA_API_TOKEN` | API token used for authentication                         |
| `JIRA_URL`       | Base Jira URL (e.g., `https://yourcompany.atlassian.net`) |

````

---

### ✅ `docs/assign-jira-issue.md`

```markdown
# 🗂️ Assign Jira Issue — Reusable Workflow

This workflow assigns a Jira issue to a specific user based on their email address. It resolves the email to a Jira `accountId` and updates the issue using the Jira REST API.

**File:** `.github/workflows/assign-jira-ticket.yml`

---

## ⚙️ Usage

```yaml
jobs:
  assign_jira_issue:
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/assign-jira-ticket.yml@main
    with:
      issue_key: "ERP-123"
      assignee_email: "user@example.com"
    secrets:
      JIRA_EMAIL: ${{ secrets.JIRA_USER }}
      JIRA_API_TOKEN: ${{ secrets.JIRA_API_TOKEN }}
      JIRA_URL: ${{ secrets.JIRA_BASE_URL }}
````

***

## 📥 Inputs

| Input            | Required | Description                            |
| ---------------- | -------- | -------------------------------------- |
| `issue_key`      | ✔️       | Jira issue key (e.g., `ERP-123`)       |
| `assignee_email` | ✔️       | Email address of the user to assign to |

***

## 🔐 Required Secrets

| Secret           | Description                                               |
| ---------------- | --------------------------------------------------------- |
| `JIRA_EMAIL`     | Email of the Jira API user                                |
| `JIRA_API_TOKEN` | API token used for authentication                         |
| `JIRA_URL`       | Base Jira URL (e.g., `https://yourcompany.atlassian.net`) |

```


👉 Do you want me to also **add a quick link section in the main README** pointing to these two docs for easy navigation? Or keep everything in one big README?
```
