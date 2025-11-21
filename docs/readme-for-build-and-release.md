# 🚀 Build & Release Java Application Workflow

**Location:** `.github/workflows/build-and-release-v3.yml`

**Reusable Components:** Stored in `reusable-actions-library/.github/workflows/` (separate repo)  

---

## 📌 What Does This Do?

This workflow **orchestrates** a complete build, package, and release pipeline:

```
1. Create Release
        ↓
2. Build JAR (from reusable-actions-library)
        ↓
3. Detect Setup Script (from reusable-actions-library)
        ↓
4. Validate Everything (in this workflow)
        ↓
5. Build Windows Installer (from reusable-actions-library)
        ↓
6. Upload to Release (from reusable-actions-library)
        ↓
7. Notify Team (from reusable-actions-library)
        ↓
✅ Users download from Release page
```

**In plain English:** Your Java code automatically compiles → packages into Windows installer → uploads to release → tells your team. **Zero manual steps after you hit "Create Release."**

---

## ⚡ Quick Start 
### Step 1: One-Time Setup
```bash
# In your repo Settings → Secrets and variables → Actions
# Add secret:
# Name: TEAMS_WEBHOOK_URL
# Value: [Your Teams webhook URL from channel settings]
```

### Step 2: Create a Release
```bash
git tag v1.0.0
git push origin v1.0.0
# Go to GitHub → Releases → Create Release from tag
```

**That's it!** Workflow runs automatically. Watch in Actions tab.

### Step 3: Download
- Release page → Assets → Download `Setup-v1.0.0.exe`

---

## 📋 What You Need (Prerequisites)

Your repo **must have:**

✅ **`build.gradle` or `build.gradle.kts`**  
   - Gradle build config (at repo root)
   - Check: `ls build.gradle`

✅ **`.iss` Inno Setup file**  
   - Windows installer configuration
   - Can be at repo root or subdirectory
   - Check: `find . -name "*.iss"`

✅ **`gradlew` executable**  
   - Must be committed to Git
   - Check: `ls -la gradlew`

✅ **`TEAMS_WEBHOOK_URL` secret**  
   - Repo Settings → Secrets → Add it
   - [How to create Teams webhook](#how-to-create-teams-webhook)

✅ **GitHub Release created**  
   - Not just a git tag, but actual Release
   - [How to create release](#how-to-create-github-release)

---

## 🔄 How It Works (The Complete Flow)

### **What Triggers This Workflow**

1. **Automatic:** Create a GitHub Release
2. **Manual:** Go to Actions → Run workflow → Override options

### **The 5-Stage Pipeline**

#### **Stage 1: Build JAR** ⏱️ 2-5 min
**Reusable Workflow:** `build-jar.yml`  
**What happens:**
- Compiles Java code with Gradle
- Produces `.jar` file
- Caches it for next stage

**Can customize:**
- Java version (17, 21, 11)
- Gradle task (jar, shadowJar, build)
- Java distribution (temurin, zulu, corretto)

📖 **Details:** See [build-jar-README.md](#build-jar)

---

#### **Stage 2: Detect Setup Script** ⏱️ 30 sec
**Reusable Workflow:** `detect-setup-script.yml`  
**What happens:**
- Scans for `.iss` Inno Setup files
- Validates script exists
- Passes path to next stage

**Fails if:** No `.iss` file found

📖 **Details:** See [detect-setup-script-README.md](#detect-setup-script)

---

#### **Stage 3: Validate** ⏱️ 30 sec
**This Workflow (inline)**  
**What happens:**
- Checks JAR build succeeded
- Verifies cache key is valid
- Safety gate before installer build

**Fails if:** JAR cache key is empty

---

#### **Stage 4: Build Installer** ⏱️ 3-5 min
**Reusable Workflow:** `build-installer.yml`  
**What happens:**
- Gets JAR from cache
- Reads `.iss` setup script
- Installs Inno Setup compiler
- Builds Windows `.exe`
- Saves as artifact

**Output:** `Setup-v1.0.0.exe`

📖 **Details:** See [build-installer-README.md](#build-installer)

---

#### **Stage 5: Upload & Notify** ⏱️ 2 min
**Reusable Workflows:** `upload-release.yml` + `teams-notifier.yml`  
**What happens:**
- Downloads `.exe` from artifacts
- Attaches to GitHub Release
- Sends Teams notification
- Users can now download

**Output:** File on Release page + Teams message

📖 **Details:** See [upload-release-README.md](#upload-release) and [teams-notifier-README.md](#teams-notifier)

---

## 🎛️ How to Trigger Manually (Testing)

### Option 1: Create Release (Auto-triggers workflow)
```bash
git tag v1.0.0
git push origin v1.0.0
# Go to GitHub → Create Release
```

### Option 2: Manual Dispatch (No release needed)
1. GitHub → Actions tab
2. Select "Build & Release Java App"
3. Click "Run workflow"
4. (Optional) Override:
   - **Java version:** 17, 21, 11
   - **Java distribution:** temurin, zulu, corretto
   - **Gradle task:** jar, shadowJar, build
5. Click "Run workflow"

---

## 📚 Reusable Workflows Documentation

This workflow **calls** 5 reusable workflows from `reusable-actions-library` repo. Each has detailed documentation:

### **1. Build JAR** {#build-jar}
📖 **[build-jar-README.md](../../reusable-actions-library/docs/build-jar-README.md)**

**Purpose:** Compile Java code using Gradle  
**Outputs:** JAR file + cache key  
**Key Inputs:**
- `java_version` (default: 17)
- `gradle_task` (default: jar)
- `java_distribution` (default: temurin)

**Troubleshooting Topics:**
- JAR cache key is empty
- Gradle wrapper not executable
- Build is super slow
- Wrong Java version detected

---

### **2. Detect Setup Script** {#detect-setup-script}
📖 **[detect-setup-script-README.md](../../reusable-actions-library/docs/detect-setup-script-README.md)**

**Purpose:** Find `.iss` Inno Setup files in repo  
**Outputs:** Path to setup script  
**Key Inputs:**
- `pattern` (default: `**/*.iss`)
- `fail_if_missing` (default: true)

**Troubleshooting Topics:**
- Setup script not found
- Multiple `.iss` files found
- Path format issues

---

### **3. Build Installer** {#build-installer}
📖 **[build-installer-README.md](../../reusable-actions-library/docs/build-installer-README.md)**

**Purpose:** Package JAR into Windows `.exe` with Inno Setup  
**Outputs:** Installer executable  
**Key Inputs:**
- `jar_cache_key` (from build-jar)
- `setup_script` (from detect-setup-script)
- `app_name`, `app_version`, `output_name`

**Troubleshooting Topics:**
- ISCC.exe not found
- .iss script has errors
- No JAR files found after cache restore
- Installer is very large (normal!)

---

### **4. Upload Release** {#upload-release}
📖 **[upload-release-README.md](../../reusable-actions-library/docs/upload-release-README.md)**

**Purpose:** Attach files to GitHub Release  
**Outputs:** Files now on Release page  
**Key Inputs:**
- `tag_name` (e.g., v1.0.0)
- `artifact_name` (from build-installer)
- `file_pattern` (default: `*.exe`)

**Troubleshooting Topics:**
- Release doesn't exist
- No files matching pattern
- Upload failed
- File already exists on release

---

### **5. Teams Notifier** {#teams-notifier}
📖 **[teams-notifier-README.md](../../reusable-actions-library/docs/teams-notifier-README.md)**

**Purpose:** Send formatted Adaptive Card to Teams channel  
**Outputs:** Teams message (side effect only)  
**Key Inputs:**
- `notification_title` (e.g., "✅ Build Succeeded!")
- `action_required_message` (what to do)
- `card_color` (Good, Warning, Attention)

**Features:**
- Auto-includes repo, branch, commit info
- Customizable card colors
- Optional file lists
- Built-in validation

**Troubleshooting Topics:**
- Teams webhook URL is empty
- Message formatting issues
- Webhook URL invalid

---

## ❌ Troubleshooting This Workflow

### **Problem: Workflow Won't Start**

**Why:** Release event didn't trigger  
**Fix:**
1. Make sure you created a GitHub **Release** (not just a git tag)
2. Go to repo → Releases → Check if v1.0.0 is there
3. If only tag exists: go to Releases → "Create Release from tag"

---

### **Problem: "JAR cache key is empty"**

**Why:** build-jar stage failed  
**Fix:**
1. Click build-jar job in workflow
2. Find error message (usually Gradle error)
3. Fix `build.gradle` or code
4. Re-run workflow

**Common causes:**
- `build.gradle` syntax error
- Missing `gradlew` file
- Java version incompatible with code

📖 **More details:** See [build-jar troubleshooting](../../reusable-actions-library/docs/build-jar-README.md#troubleshooting)

---

### **Problem: ".iss setup script not found"**

**Why:** No `.iss` file in repo  
**Fix:**
1. Create `.iss` file using Inno Setup IDE (locally)
2. Commit to Git: `git add setup.iss && git commit`
3. Push: `git push`
4. Re-run workflow

**Don't have template?** Ask Platform Engineering for `.iss` example

📖 **More details:** See [detect-setup-script troubleshooting](../../reusable-actions-library/docs/detect-setup-script-README.md#troubleshooting)

---

### **Problem: "Teams webhook URL is empty"**

**Why:** `TEAMS_WEBHOOK_URL` secret not configured  
**Fix:**
1. Repo Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Name: `TEAMS_WEBHOOK_URL`
4. Value: [Your Teams webhook]
5. Save
6. Re-run workflow

**How to get Teams webhook:** See [How to Create Teams Webhook](#how-to-create-teams-webhook)

📖 **More details:** See [teams-notifier troubleshooting](../../reusable-actions-library/docs/teams-notifier-README.md#troubleshooting)

---

### **Problem: Workflow Stuck / Timed Out**

**Why:** Usually Gradle downloading dependencies (slow on first build)  
**What to do:**
1. Check logs: "downloading dependencies"
2. Wait 5-10 minutes (first build is slower)
3. Subsequent builds use cache (faster)
4. If stuck >15 min: cancel and retry

---

### **Problem: Installer is very large (100+ MB)**

**Why:** Java apps include JVM + all dependencies (normal!)  
**It's OK if:**
- Size: 50-200 MB (typical)
- File created successfully
- Installer runs on test machine

**Not a problem.** This is expected behavior.

---

## 📖 Setup Guides

### How to Create Teams Webhook {#how-to-create-teams-webhook}

1. Open Microsoft Teams
2. Go to your channel (e.g., #releases)
3. Click **...** (more options) → **Connectors**
4. Search: "Incoming Webhook"
5. Click **Configure**
6. Give it a name (e.g., "GitHub Releases")
7. (Optional) Upload icon
8. Click **Create**
9. Copy the webhook URL
10. Go to GitHub repo → Settings → Secrets → New secret
11. Name: `TEAMS_WEBHOOK_URL`
12. Paste URL → Save

---

### How to Create GitHub Release {#how-to-create-github-release}

**Method 1: From tag**
```bash
git tag v1.0.0
git push origin v1.0.0
```
Then: GitHub → Releases → "Create Release from tag"

**Method 2: Directly on GitHub**
1. GitHub → Releases
2. "Create a new release"
3. Tag: `v1.0.0`
4. Title: `Version 1.0.0`
5. Description: (release notes)
6. Click "Publish release"

---

## 📊 Real-World Example

### Scenario: Release v2.5.0

**You do:**
```bash
git tag v2.5.0
git push origin v2.5.0
# Go to GitHub → Create Release from tag
```

**Workflow does (automatically):**
```
✅ Stage 1: Build JAR (Java 17 + Gradle)
   → build/libs/myapp-2.5.0.jar created
   → Cache key: jar-abc123def

✅ Stage 2: Detect Setup
   → Found: setup.iss

✅ Stage 3: Validate
   → JAR cache key verified
   → All requirements met

✅ Stage 4: Build Installer (Inno Setup)
   → Setup-v2.5.0.exe created

✅ Stage 5: Upload to Release
   → Attached to v2.5.0 release

✅ Stage 6: Notify Team (Teams)
   → Message sent: "✅ Build Succeeded!"
   → Team sees notification in channel
```

**Your users:**
- Go to Releases page
- Download `Setup-v2.5.0.exe`
- Run installer
- App installed ✅

**Total time:** 12-15 minutes, zero manual steps.

---

## 🎛️ Customization Examples

### Example 1: Build with Java 21
```
Actions → Run workflow
→ Set java_version to "21"
→ Run workflow
```

### Example 2: Create Fat JAR (All Dependencies Inside)
```
Actions → Run workflow
→ Set gradle_task to "shadowJar"
→ Run workflow
```

### Example 3: Use Corretto Java
```
Actions → Run workflow
→ Set java_distribution to "corretto"
→ Run workflow
```

---

## ✅ Pre-Release Checklist

### Before First Release
- [ ] `build.gradle` or `build.gradle.kts` exists
- [ ] `.iss` Inno Setup file in repo
- [ ] `gradlew` file committed (check: `ls -la gradlew`)
- [ ] `TEAMS_WEBHOOK_URL` secret added
- [ ] `.gradle/wrapper/` folder committed
- [ ] Code builds locally (`./gradlew jar`)

### Before Each Release
- [ ] Code merged to main/master
- [ ] Version bumped in `build.gradle`
- [ ] Tag created: `git tag v1.2.3`
- [ ] Tag pushed: `git push origin v1.2.3`
- [ ] GitHub Release created (not just tag)
- [ ] Workflow triggered and running

---

## 🔗 Related Documentation

### In This Repo (`.github/workflows/`)
- **Main Workflow:** `build-and-release-v3.yml`

### In Reusable Library (`reusable-actions-library/.github/workflows/`)
- **[build-jar.yml](../../reusable-actions-library/docs/build-jarREADME.md)** - Compile Java
- **[detect-setup-script.yml](../../reusable-actions-library/docs/detect-setup-scriptREADME.md)** - Find `.iss`
- **[build-installer.yml](../../reusable-actions-library/docs/build-installerREADME.md)** - Package `.exe`
- **[upload-release.yml](../../reusable-actions-library/docs/upload-releaseREADME.md)** - Upload assets
- **[teams-notifier.yml](../../reusable-actions-library/docs/teams-notifierREADME.md)** - Send Teams message

### External Links
- [Inno Setup Documentation](https://jrsoftware.org/isinfo.php)
- [Gradle Documentation](https://docs.gradle.org)
- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Microsoft Teams Webhooks](https://learn.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/connectors-using)

---

## 🤔 FAQ

**Q: Can I use this without creating releases?**  
A: Yes, use "Run workflow" (manual dispatch). See [Manual Dispatch section](#how-to-trigger-manually-testing).

**Q: Can I customize the installer appearance?**  
A: Yes, edit your `.iss` file. See [build-installerREADME.md troubleshooting](../../reusable-actions-library/docs/build-installerREADME.md#troubleshooting).

**Q: What Java versions are supported?**  
A: 11, 17, 21 (or any version supported by GitHub Actions).

**Q: Can I skip Teams notifications?**  
A: Yes, but not recommended. Contact Platform Eng if needed.

**Q: How long does the whole thing take?**  
A: First release: 12-15 min. Subsequent: 8-10 min (cached builds are faster).

**Q: Can I use Maven instead of Gradle?**  
A: Not with this workflow. Contact Platform Engineering.

**Q: Where do I see the logs?**  
A: GitHub → Actions tab → Select workflow run → View each job

**Q: Can I run tests before building?**  
A: Yes, set `gradle_task` to `build` (includes tests).

---
