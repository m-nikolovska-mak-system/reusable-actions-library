

# 📝 Assign Jira Issue — Reusable Workflow

**File:** [`.github/workflows/assign-jira-ticket.yml`](https://github.com/m-nikolovska-mak-system/reusable-actions-library/blob/main/.github/workflows/assign-jira-ticket.yml) — Reusable workflow to safely assign a Jira issue to a user with email validation and assignable check.


---

## 🎯 What This Does

Assigns a Jira ticket to a specified user using the Jira REST API, with:

* Input validation for issue key and email
* User lookup by email
* Checks if user is assignable for the issue before assignment
* Supports both PUT and POST assignment requests

**What you give it:**

* Jira issue key
* Assignee email

**What you get back:**

* ✅ Confirmation of assignment (logs only, no direct output)

---

## 📥 Inputs (What You Customize)

| Input            | Type   | Required? | What It Does                | Example                |
| ---------------- | ------ | --------- | --------------------------- | ---------------------- |
| `issue_key`      | string | ✅ YES     | Jira issue key to assign    | `ERP-123`              |
| `assignee_email` | string | ✅ YES     | Email of the user to assign | `john.doe@example.com` |

---

## 🔒 Secrets (Required)

| Secret           | What It Is                                                   |
| ---------------- | ------------------------------------------------------------ |
| `JIRA_EMAIL`     | Jira user email for API authentication                       |
| `JIRA_API_TOKEN` | Jira API token for authentication                            |
| `JIRA_URL`       | Base URL for Jira instance (`https://company.atlassian.net`) |

---

## 💡 Usage Examples

### Example 1: Assign an Ticket

```yaml
jobs:
  assign_issue:
    uses: reusable-actions-library/.github/workflows/assign-jira-ticket.yml@main
    with:
      issue_key: ERP-123
      assignee_email: john.doe@example.com
    secrets:
      JIRA_EMAIL: ${{ secrets.JIRA_USER }}
      JIRA_API_TOKEN: ${{ secrets.JIRA_API_TOKEN }}
      JIRA_URL: ${{ secrets.JIRA_BASE_URL }}
```

