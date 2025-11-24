# 🗂️ Assign Jira Issue — Reusable Workflow

This reusable GitHub Actions workflow assigns a Jira issue to a specific user based on their email address. It resolves the email to a Jira `accountId` and updates the issue using the Jira REST API.

**File:** [`.github/workflows/assign-jira-ticket.yml`](https://github.com/m-nikolovska-mak-system/reusable-actions-library/blob/main/.github/workflows/assign-jira-ticket

---

## ⚙️ Usage

```yaml
jobs:
  assign_jira_issue:
    uses: ./.github/workflows/assign-jira.yml
    with:
      issue_key: "ABC-123"
      assignee_email: "user@example.com"
    secrets:
      JIRA_EMAIL: ${{ secrets.JIRA_EMAIL }}
      JIRA_API_TOKEN: ${{ secrets.JIRA_API_TOKEN }}
      JIRA_URL: ${{ secrets.JIRA_URL }}
```

## 📥 Inputs

| Input            | Required | Description                                 |
|------------------|----------|---------------------------------------------|
| `issue_key`      | ✔️        | Jira issue key (e.g., `ABC-123`)            |
| `assignee_email` | ✔️        | Email address of the user to assign to      |

---

## 🔐 Required Secrets

| Secret            | Description                                      |
|-------------------|--------------------------------------------------|
| `JIRA_EMAIL`      | Email of the Jira API user                        |
| `JIRA_API_TOKEN`  | API token used for authentication                 |
| `JIRA_URL`        | Base Jira URL (e.g., `https://yourcompany.atlassian.net`) |

---

## 🛠️ What the Workflow Does

### 1. Install tools  
Installs `jq` and `python3` for JSON processing and URL encoding.

### 2. Validate secrets  
Checks that all required Jira secrets are available before continuing.

### 3. Look up Jira user by email  
Queries the Jira API to find the user’s `accountId`.  
If the user cannot be found, the workflow prints the API response and exits.

### 4. Assign the Jira issue  
Uses the resolved `accountId` to assign the issue via a `PUT` request.  
A successful assignment returns **204 No Content**.

