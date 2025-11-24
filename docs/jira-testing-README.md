Got it! Here’s a concise README draft for your **Mega Jira Workflow** with brief explanation and proper links to the reusable workflows:

---

# 🚀 Mega Jira Workflow

**File:** [`.github/workflow-templates/jira-main-flow.yml`](https://github.com/m-nikolovska-mak-system/.github/blob/main/workflow-templates/jira-main-flow.yml) — Creates a Jira issue **and** assigns it to a user in one workflow run.

This workflow combines two reusable workflows: **create issue** and **assign issue**, making it easy to handle Jira tickets end-to-end from GitHub Actions.


---

## 📥 Inputs

| Input            | Required | Description                              |
| ---------------- | -------- | ---------------------------------------- |
| `project_key`    | ✅        | Jira project key (e.g., `ERP`)           |
| `summary`        | ✅        | Jira issue summary                       |
| `description`    | ❌        | Optional description text                |
| `assignee_email` | ✅        | Email of the user to assign the issue to |

---

## 🔗 Reusable Workflows Used

| Workflow          | Description                                                         | Link                                                                                                                     |
| ----------------- | ------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| Create Jira Issue | Creates a Jira issue in a specified project and returns `issue_key` | [README](https://github.com/m-nikolovska-mak-system/reusable-actions-library/blob/main/docs/create-jira-issue-README.md) |
| Assign Jira Issue | Assigns a Jira issue to a user by email                             | [README](https://github.com/m-nikolovska-mak-system/reusable-actions-library/blob/main/docs/assign-jira-iisue-README.md) |

---

## 💡 Usage Example

```yaml
jobs:
  create_and_assign:
    uses: ./.github/workflows/mega-jira-workflow.yml
    with:
      project_key: ERP
      summary: "Test issue from GitHub Actions"
      description: "This is a test"
      assignee_email: your.email@company.com
    secrets:
      JIRA_USER: ${{ secrets.JIRA_USER }}
      JIRA_API_TOKEN: ${{ secrets.JIRA_API_TOKEN }}
      JIRA_BASE_URL: ${{ secrets.JIRA_BASE_URL }}
```

---
