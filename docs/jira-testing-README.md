# 🧪 Jira Workflows Testing & Setup Guide

---

## 🎯 What We're Testing

You have **3 workflows** to test:

1. ✅ **create-jira-issue.yml** - Creates Jira tickets
2. ✅ **assign-jira-ticket.yml** - Assigns tickets to users
3. ✅ **Mega Jira Workflow** - Combines both (create → assign)

---

## 📋 Prerequisites Checklist

Before testing, make sure you have:

### In Jira
- [ ] Valid Jira instance (Cloud or Server)
- [ ] Project key (e.g., `ERP`, `PROJ`)
- [ ] Bot user with permissions:
  - [ ] Create Issues
  - [ ] Assign Issues
  - [ ] Browse Projects
- [ ] Your email registered in Jira
- [ ] API token generated ([Get one here](https://id.atlassian.com/manage-profile/security/api-tokens))

### In GitHub
- [ ] Three secrets configured in repo:
  - [ ] `JIRA_USER` (bot email)
  - [ ] `JIRA_API_TOKEN` (bot token)
  - [ ] `JIRA_BASE_URL` (e.g., `https://company.atlassian.net`)

---

## 🔧 Setup (One-Time, 10 min)

### Step 1: Create Jira Bot User (5 min)

**If you don't have a bot user yet:**

1. Go to Jira → People → Invite people
2. Create user:
   ```
   Email: jira-bot@company.com
   Name: GitHub Actions Bot
   ```
3. Add to project with role that has:
   - Create Issues permission
   - Assign Issues permission

**If using existing user:**
- Just make sure they have the permissions above

---

### Step 2: Generate API Token (2 min)

1. Log in as bot user
2. Go to: https://id.atlassian.com/manage-profile/security/api-tokens
3. Click "Create API token"
4. Name: `GitHub Actions`
5. Click "Create"
6. **Copy the token** (you won't see it again!)

---

### Step 3: Add GitHub Secrets (3 min)

1. Go to your repo → Settings → Secrets and variables → Actions
2. Click "New repository secret" (3 times)

**Secret 1:**
```
Name: JIRA_USER
Value: jira-bot@company.com
```

**Secret 2:**
```
Name: JIRA_API_TOKEN
Value: ATATT... (paste your token)
```

**Secret 3:**
```
Name: JIRA_BASE_URL
Value: https://company.atlassian.net
```

**Important:** No trailing slash on URL!

---

## 🧪 Test Plan

### Test 1: Create Jira Issue (Basic) ⏱️ 5 min

**Purpose:** Verify issue creation works

**Steps:**
1. Go to Actions tab
2. Find workflow: "Mega Jira Workflow" (or your test workflow)
3. Click "Run workflow"
4. Fill in:
   ```
   project_key: ERP           (your real project!)
   summary: Test issue from GitHub Actions
   description: This is a test
   assignee_email: your.email@company.com
   ```
5. Click "Run workflow"
6. Wait ~20 seconds

**Expected Result:**
- ✅ Workflow succeeds
- ✅ New issue appears in Jira (e.g., `ERP-123`)
- ✅ Issue is assigned to you
- ✅ GitHub summary shows clickable Jira link

**If it fails:** See [Troubleshooting](#troubleshooting) below

---

### Test 2: Create Without Description ⏱️ 3 min

**Purpose:** Verify optional description works

**Steps:**
Same as Test 1, but:
```
description: (leave empty)
```

**Expected Result:**
- ✅ Issue created successfully
- ✅ No description field in Jira

---

### Test 3: Invalid Project Key ⏱️ 2 min

**Purpose:** Verify validation catches errors

**Steps:**
```
project_key: invalid-key
summary: Test
description: Test
assignee_email: your.email@company.com
```

**Expected Result:**
- ❌ Fails with: "Invalid project key format"
- ❌ Clear error message with tip

---

### Test 4: Non-existent Assignee ⏱️ 3 min

**Purpose:** Verify user lookup works

**Steps:**
```
project_key: ERP
summary: Test
description: Test
assignee_email: nonexistent@example.com
```

**Expected Result:**
- ✅ Issue created
- ❌ Assignment fails with: "Jira user not found"
- ❌ Clear error message

---

### Test 5: Create + Assign (Full Flow) ⏱️ 5 min

**Purpose:** Verify end-to-end workflow

**Steps:**
Run with all valid inputs (your real data)

**Expected Result:**
- ✅ Step 1: Issue created (e.g., `ERP-123`)
- ✅ Step 2: Issue assigned to specified user
- ✅ Both summaries show success
- ✅ Jira shows issue assigned correctly

---

### Test 6: Idempotency (Assign Twice) ⏱️ 5 min

**Purpose:** Verify safe to run multiple times

**Steps:**
1. Create issue manually in Jira (e.g., `ERP-456`)
2. Run assign workflow twice with same issue
3. Use your email as assignee

**Expected Result:**
- ✅ First run: Assigns successfully
- ✅ Second run: "Already assigned" (skips reassignment)
- ✅ No errors on second run

---

## ❌ Troubleshooting

### Problem: "JIRA_EMAIL secret is missing"

**Fix:**
1. Check secret name matches exactly: `JIRA_USER` in secrets
2. Workflow must use: `JIRA_EMAIL: ${{ secrets.JIRA_USER }}`
3. Case-sensitive!

---

### Problem: "Project ERP not found or inaccessible"

**Fix:**
1. Verify project exists in Jira
2. Check bot user has access to project
3. Try with your personal credentials first:
   ```bash
   curl -u "your-email@company.com:YOUR_TOKEN" \
     "https://company.atlassian.net/rest/api/3/project/ERP"
   ```
4. If you see the project, bot needs access

---

### Problem: "Issue type 'Task' not found"

**Fix:**
1. Check available issue types in project settings
2. Common types: `Task`, `Bug`, `Story`, `Epic`
3. Case-sensitive! Use exact name from Jira
4. Or check programmatically:
   ```bash
   curl -u "email:token" \
     "https://company.atlassian.net/rest/api/3/issue/createmeta?projectKeys=ERP&expand=projects.issuetypes"
   ```

---

### Problem: "Failed to create Jira issue (HTTP 403)"

**Fix:**
1. Bot needs "Create Issues" permission
2. Jira → Project Settings → Permissions
3. Add bot user's role to "Create Issues"
4. Try again

---

### Problem: "Jira user not found for email"

**Fix:**
1. Check email spelling/typos
2. Verify user exists in Jira (People → Search)
3. User might be deactivated
4. User needs project access

---

### Problem: "Assignment failed (HTTP 401)"

**Fix:**
1. API token expired or invalid
2. Generate new token
3. Update `JIRA_API_TOKEN` secret
4. Try again

---

### Problem: Workflow creates issue but assign fails

**This is OK!** The workflows are independent:
1. Issue is created ✅
2. Assignment failed ❌
3. Fix assignment issue
4. Run assign workflow manually for that issue

**Or:** Delete test issue and run mega workflow again

---

## 🎯 Success Criteria

**All tests passed if:**
- ✅ Test 1: Issue created + assigned
- ✅ Test 2: Issue created without description
- ✅ Test 3: Invalid input caught with clear error
- ✅ Test 4: User validation works
- ✅ Test 5: Full flow works end-to-end
- ✅ Test 6: Idempotency works (safe to retry)

**If 5/6 pass:** Good enough for production!  
**If <5 pass:** Fix issues using troubleshooting guide

---

## 📊 What Good Test Results Look Like

### Successful Create + Assign:

```
Job: Create Jira Issue
✅ All validations passed
✅ Project found: Engineering
✅ Issue type 'Task' is valid
✅ Jira issue created successfully!
   Issue Key: ERP-123
   URL: https://company.atlassian.net/browse/ERP-123

Summary:
📋 Jira Issue Creation Summary
Issue: ERP-123 (clickable link)
Project: ERP (Engineering)
Type: Task
Summary: Test issue from GitHub Actions

Job: Assign Jira Issue
✅ All validations passed
✅ Found Jira user: John Doe
✅ Issue found: ERP-123
📌 Assigning ERP-123 → John Doe
🎉 Successfully assigned!

Summary:
📋 Jira Assignment Summary
Issue: ERP-123
Summary: Test issue
Status: Open
Result: ✅ Assigned to John Doe
```

---

## 🔐 Security Checklist

Before going to production:

- [ ] Bot user has minimal permissions (only what's needed)
- [ ] API token is stored in GitHub secrets (never in code)
- [ ] API token is rotated every 90 days
- [ ] Bot user is separate from personal accounts
- [ ] Workflow logs don't expose secrets
- [ ] Only trusted team members can trigger workflows

---

## 📝 Post-Testing Cleanup

After testing:

1. **Delete test issues** (optional)
   - Go to Jira
   - Find test issues (search "Test issue from GitHub")
   - Delete or mark as done

2. **Document working config**
   - Save project keys that work
   - Save issue types available
   - Share with team

3. **Update workflows if needed**
   - Adjust default issue type
   - Update project keys
   - Commit changes

---

## 🚀 Ready for Production

Once all tests pass:

1. ✅ Create real workflow in `.github/workflows/`
2. ✅ Update with your project keys
3. ✅ Document for team
4. ✅ Share Jira links in Slack/Teams
5. ✅ Monitor first few runs
6. ✅ Celebrate! 🎉

---

## 💡 Pro Tips

**Tip 1: Test with real data**
- Use actual project keys
- Use real team emails
- Test with your own email first

**Tip 2: Check Jira immediately**
- After workflow runs, open Jira
- Verify issue looks correct
- Check assignee, type, description

**Tip 3: Use workflow_dispatch for testing**
- Manual trigger = easy testing
- Can re-run anytime
- No need to commit code changes

**Tip 4: Save test credentials**
```bash
# Keep these handy for manual API testing
JIRA_EMAIL="jira-bot@company.com"
JIRA_TOKEN="ATATT..."
JIRA_URL="https://company.atlassian.net"

# Test commands:
# List projects
curl -u "$JIRA_EMAIL:$JIRA_TOKEN" "$JIRA_URL/rest/api/3/project"

# Get project
curl -u "$JIRA_EMAIL:$JIRA_TOKEN" "$JIRA_URL/rest/api/3/project/ERP"

# Search user
curl -u "$JIRA_EMAIL:$JIRA_TOKEN" "$JIRA_URL/rest/api/3/user/search?query=john@company.com"
```

