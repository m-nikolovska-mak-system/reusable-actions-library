# 📑 GitHub Workflows Documentation Index

**Repository:** `.github/workflows/`  
**Purpose:** Central hub for all workflow documentation  

---

## 🎯 Quick Navigation

### 🚀 **Main Workflows** (In This Repo)
- **[Build & Release Java Application](#-build--release-java-application)** - Complete end-to-end pipeline
  - Location: `.github/workflows/build-and-release-v3.yml`
  - Orchestrates 5 reusable workflows
  - Auto-triggered on GitHub Release creation

### 🔧 **Reusable Workflows** (In `reusable-actions-library` Repo)
- **[Build JAR](#-1-build-jar)** - Compile Java with Gradle
- **[Detect Setup Script](#-2-detect-setup-script)** - Find Inno Setup files
- **[Build Installer](#-3-build-installer)** - Package into Windows .exe
- **[Upload Release](#-4-upload-release)** - Attach files to GitHub Release
- **[Teams Notifier](#-5-teams-notifier)** - Send Teams notifications

---

## 🚀 Build & Release Java Application

**File:** `.github/workflows/build-and-release-v3.yml`  
**Type:** Main orchestration workflow (in this repo)  
**Status:** ✅ Production Ready  
**Triggers:** Manual dispatch + Release creation event

### What It Does
Automates complete Java app build & release pipeline:
```
Create Release → Build JAR → Validate → Package Installer → 
Upload to Release → Notify Team ✅
```

### Quick Start
```bash
git tag v1.0.0 && git push origin v1.0.0
# Create GitHub Release from tag
# Workflow triggers automatically
```

### Key Features
- ✅ Multi-stage pipeline (5 stages)
- ✅ Concurrent build prevention
- ✅ Input validation before installer creation
- ✅ Windows installer (.exe) packaging
- ✅ Automatic GitHub Release asset upload
- ✅ Team notifications (success/failure)
- ✅ Flexible customization (Java version, Gradle task, etc.)

### Documentation
📖 **[BUILD-AND-RELEASE-README.md](./BUILD-AND-RELEASE-README.md)** (Main documentation for this workflow)

**Sections:**
- Quick start setup
- Prerequisites checklist
- How each of the 5 stages works
- Troubleshooting guide
- Real-world examples
- Links to all reusable workflow docs

### Common Tasks

| Task | How |
|------|-----|
| Create first release | [See Quick Start](./BUILD-AND-RELEASE-README.md#quick-start) |
| Manual test build | [See Manual Dispatch](./BUILD-AND-RELEASE-README.md#how-to-trigger-manually-testing) |
| Debug failed build | [See Troubleshooting](./BUILD-AND-RELEASE-README.md#troubleshooting) |
| Customize Java version | [See Customization Examples](./BUILD-AND-RELEASE-README.md#customization-examples) |
| Setup Teams notifications | [See Teams Webhook Setup](./BUILD-AND-RELEASE-README.md#how-to-create-teams-webhook) |

---

## 🔧 Reusable Workflows

These are located in the **`reusable-actions-library`** repository and are called by the main workflow above.

### 📖 1. Build JAR

**File:** `reusable-actions-library/.github/workflows/build-jar.yml`  
**Purpose:** Compile Java source code using Gradle  
**Status:** ✅ Production Ready

**What it does:**
- Checks out code
- Installs Java (version configurable)
- Runs Gradle compile task
- Produces `.jar` artifact
- Caches JAR for next stages

**Typical Duration:** 2-5 minutes (first build slower due to dependency download)

**Key Outputs:**
- `jar_cache_key` - Unique identifier to retrieve JAR later
- `jar_filename` - Name of compiled JAR
- `jar_path` - Full path to JAR file

**Used By:** build-and-release workflow (Stage 1)

**Documentation:**
📖 **[build-jar-README.md](../reusable-actions-library/docs/build-jar-README.md)**

**Common Issues:**
- JAR cache key is empty → [See troubleshooting](../reusable-actions-library/docs/build-jar-README.md#troubleshooting)
- Gradle wrapper not executable → [See troubleshooting](../reusable-actions-library/docs/build-jar-README.md#troubleshooting)
- Build slow on first run → Normal, uses cache after

---

### 📖 2. Detect Setup Script

**File:** `reusable-actions-library/.github/workflows/detect-setup-script.yml`  
**Purpose:** Scan repository for Inno Setup (`.iss`) files  
**Status:** ✅ Production Ready

**What it does:**
- Searches for `.iss` files in repo
- Validates setup script exists
- Returns path to setup script
- Fails fast if script missing

**Typical Duration:** 30 seconds

**Key Outputs:**
- `setup_script` - Path to detected `.iss` file

**Used By:** build-and-release workflow (Stage 2)

**Documentation:**
📖 **[detect-setup-script-README.md](../reusable-actions-library/docs/detect-setup-script-README.md)**

**Common Issues:**
- Setup script not found → [See troubleshooting](../reusable-actions-library/docs/detect-setup-script-README.md#troubleshooting)
- Multiple `.iss` files → [See troubleshooting](../reusable-actions-library/docs/detect-setup-script-README.md#troubleshooting)

---

### 📖 3. Build Installer

**File:** `reusable-actions-library/.github/workflows/build-installer.yml`  
**Purpose:** Package JAR into Windows `.exe` installer  
**Status:** ✅ Production Ready  
**Environment:** Windows runner (builds `.exe`)

**What it does:**
- Restores JAR from cache
- Validates setup script syntax
- Installs Inno Setup compiler
- Compiles installer executable
- Uploads `.exe` as artifact

**Typical Duration:** 3-5 minutes

**Key Outputs:**
- `installer_artifact_name` - Name of uploaded artifact
- `installer_filename` - Name of `.exe` file

**Used By:** build-and-release workflow (Stage 4)

**Documentation:**
📖 **[build-installer-README.md](../reusable-actions-library/docs/build-installer-README.md)**

**Common Issues:**
- ISCC.exe not found → [See troubleshooting](../reusable-actions-library/docs/build-installer-README.md#troubleshooting)
- `.iss` script has errors → [See troubleshooting](../reusable-actions-library/docs/build-installer-README.md#troubleshooting)
- No JAR files found → [See troubleshooting](../reusable-actions-library/docs/build-installer-README.md#troubleshooting)

**Tip:** Installer size 50-200 MB is normal (includes JVM + dependencies)

---

### 📖 4. Upload Release

**File:** `reusable-actions-library/.github/workflows/upload-release.yml`  
**Purpose:** Attach built files to GitHub Release  
**Status:** ✅ Production Ready

**What it does:**
- Downloads artifact from previous job
- Validates files exist
- Attaches to GitHub Release
- Makes downloadable to users

**Typical Duration:** 1 minute

**Produces:** No outputs (side effect: files on Release page)

**Used By:** build-and-release workflow (Stage 5)

**Documentation:**
📖 **[upload-release-README.md](../reusable-actions-library/docs/upload-release-README.md)**

**Common Issues:**
- Release doesn't exist → [See troubleshooting](../reusable-actions-library/docs/upload-release-README.md#troubleshooting)
- No files matching pattern → [See troubleshooting](../reusable-actions-library/docs/upload-release-README.md#troubleshooting)
- Upload failed → [See troubleshooting](../reusable-actions-library/docs/upload-release-README.md#troubleshooting)

---

### 📖 5. Teams Notifier

**File:** `reusable-actions-library/.github/workflows/teams-notifier.yml`  
**Purpose:** Send formatted Adaptive Cards to Microsoft Teams  
**Status:** ✅ Production Ready

**What it does:**
- Builds formatted Teams message
- Includes build metadata (repo, branch, commit)
- Sends to Teams channel via webhook
- Shows success/failure with colors

**Typical Duration:** 30 seconds

**Produces:** No outputs (side effect: Teams message)

**Used By:** build-and-release workflow (Stage 5-6, both success & failure paths)

**Documentation:**
📖 **[teams-notifier-README.md](../reusable-actions-library/docs/teams-notifier-README.md)**

**Common Issues:**
- Teams webhook URL is empty → [See troubleshooting](../reusable-actions-library/docs/teams-notifier-README.md#troubleshooting)
- Message doesn't appear → [See troubleshooting](../reusable-actions-library/docs/teams-notifier-README.md#troubleshooting)
- Wrong card color → [See troubleshooting](../reusable-actions-library/docs/teams-notifier-README.md#troubleshooting)

---

## 🗺️ Data Flow Architecture

```
┌────────────────────────────────────────────────────┐
│  Main Workflow: build-and-release-v3.yml           │
│  (Orchestrator - this repo)                        │
└────────────────────────────────────────────────────┘
         ↓ calls (via workflow_call)
    ┌────┴────┬──────────┬────────────┬─────────────┐
    ↓         ↓          ↓            ↓             ↓
┌────────┐ ┌──────┐ ┌────────────┐ ┌────────┐ ┌─────────┐
│build   │ │detect│ │Validate    │ │build   │ │Teams    │
│jar     │ │setup │ │Inputs      │ │install │ │Notifier │
└────────┘ └──────┘ └────────────┘ │(called │ │(called  │
   ↓         ↓          ↓           │ Stage4)│ │Stage5-6)│
outputs:  outputs:    ↓           └────────┘ └─────────┘
- key   - path      Check jar     ↓
- file              cache key    outputs:
- path                           - artifact
                                - filename
                                       ↓
                            ┌──────────────────┐
                            │Upload Release    │
                            │(Stage 5)         │
                            └──────────────────┘
                                     ↓
                            Files on Release page ✅
```

---

## 📚 Documentation Map

### For Different Roles

**I'm a Developer - Where do I start?**
1. Read: [BUILD-AND-RELEASE-README.md](./BUILD-AND-RELEASE-README.md) (Main overview)
2. Do: [Quick Start section](./BUILD-AND-RELEASE-README.md#quick-start)
3. If stuck: [Troubleshooting section](./BUILD-AND-RELEASE-README.md#troubleshooting)

**I'm a DevOps Engineer - I need all details**
1. Read: [BUILD-AND-RELEASE-README.md](./BUILD-AND-RELEASE-README.md)
2. Study each reusable workflow:
   - [build-jar-README.md](../reusable-actions-library/docs/build-jar-README.md)
   - [detect-setup-script-README.md](../reusable-actions-library/docs/detect-setup-script-README.md)
   - [build-installer-README.md](../reusable-actions-library/docs/build-installer-README.md)
   - [upload-release-README.md](../reusable-actions-library/docs/upload-release-README.md)
   - [teams-notifier-README.md](../reusable-actions-library/docs/teams-notifier-README.md)
3. Review: [Workflow Ecosystem Guide](../reusable-actions-library/docs/WORKFLOWS-OVERVIEW.md)

**I'm an Intern - I'm new to GitHub Actions**
1. Read: [Workflow Ecosystem Guide](../reusable-actions-library/docs/WORKFLOWS-OVERVIEW.md) (Easy intro)
2. Read: [BUILD-AND-RELEASE-README.md](./BUILD-AND-RELEASE-README.md) (Main workflow)
3. Try: Create your first release (hands-on learning)
4. Debug: If it fails, check troubleshooting + ask team

---

## 🔍 Troubleshooting by Error Message

| Error | Workflow | Solution |
|-------|----------|----------|
| "JAR cache key is empty" | build-jar | [See docs](../reusable-actions-library/docs/build-jar-README.md#troubleshooting) |
| ".iss setup script not found" | detect-setup-script | [See docs](../reusable-actions-library/docs/detect-setup-script-README.md#troubleshooting) |
| "ISCC.exe not found" | build-installer | [See docs](../reusable-actions-library/docs/build-installer-README.md#troubleshooting) |
| "No files matching pattern" | upload-release | [See docs](../reusable-actions-library/docs/upload-release-README.md#troubleshooting) |
| "Teams webhook URL is empty" | teams-notifier | [See docs](../reusable-actions-library/docs/teams-notifier-README.md#troubleshooting) |

---

## ✅ Pre-Launch Checklist

### First Time Setup (One per repo)
- [ ] Read: [BUILD-AND-RELEASE-README.md Quick Start](./BUILD-AND-RELEASE-README.md#quick-start)
- [ ] Have: `build.gradle` file
- [ ] Have: `.iss` Inno Setup file
- [ ] Have: `TEAMS_WEBHOOK_URL` secret configured
- [ ] Have: `gradlew` file committed

### Before Each Release
- [ ] Code merged to main
- [ ] Version bumped in `build.gradle`
- [ ] Git tag created: `git tag v1.2.3`
- [ ] Git tag pushed: `git push origin v1.2.3`
- [ ] GitHub Release created (from tag, not just tag)
- [ ] Watch workflow run in Actions tab

---

## 📞 Support & Contact

| Question | Answer |
|----------|--------|
| Workflow documentation questions | Check relevant README in this list |
| Setup/config help | See [Setup Guides](./BUILD-AND-RELEASE-README.md#setup-guides) |
| Bug report | Open issue in `reusable-actions-library` repo |
| Feature request | Slack #platform-engineering |
| Urgent help | Slack #platform-engineering or mention @platform-engineering |

---

## 🔗 External Links

- **[Inno Setup Documentation](https://jrsoftware.org/isinfo.php)** - Windows installer creation
- **[Gradle Documentation](https://docs.gradle.org)** - Java build tool
- **[GitHub Actions Docs](https://docs.github.com/en/actions)** - GitHub's workflow platform
- **[Microsoft Teams Webhooks](https://learn.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/connectors-using)** - Teams notifications
- **[Reusable Actions Library Repo](https://github.com/m-nikolovska-mak-system/reusable-actions-library)** - All reusable workflows

---

## 📋 All Documentation Files

### In This Repo (`.github/workflows/`)
```
.
├── build-and-release-v3.yml          ← Main workflow file
└── BUILD-AND-RELEASE-README.md       ← Main documentation (this index)
```

### In Reusable Library (`reusable-actions-library/docs/`)
```
docs/
├── build-jar-README.md               ← Build JAR workflow docs
├── detect-setup-script-README.md     ← Detect setup docs
├── build-installer-README.md         ← Build installer docs
├── upload-release-README.md          ← Upload release docs
├── teams-notifier-README.md          ← Teams notifier docs
└── WORKFLOWS-OVERVIEW.md             ← Ecosystem guide
```

---

## 🎓 Learning Path

### Week 1: Basics
- [ ] Read BUILD-AND-RELEASE-README.md
- [ ] Understand the 5-stage pipeline
- [ ] Create first release (hands-on)

### Week 2: Intermediate
- [ ] Read each reusable workflow README
- [ ] Debug a failed workflow
- [ ] Customize a workflow run

### Week 3: Advanced
- [ ] Modify `.iss` setup script
- [ ] Override Java versions
- [ ] Create multiple workflows using these reusables

### Week 4: Expert
- [ ] Help teammates understand
- [ ] Document custom implementations
- [ ] Suggest improvements to Platform Eng

---

## 🎯 Quick Decision Tree

```
Need to create a release?
├─ Yes → Go to BUILD-AND-RELEASE-README.md Quick Start
└─ No → What do you need?

Workflow failed?
├─ Yes → Go to BUILD-AND-RELEASE-README.md Troubleshooting
└─ No → What do you need?

Want to understand how it works?
├─ Yes → Go to WORKFLOWS-OVERVIEW.md or each reusable README
└─ No → What do you need?

Need help?
├─ Slack #platform-engineering
├─ Check relevant README troubleshooting
└─ Open issue in reusable-actions-library repo
```

---
