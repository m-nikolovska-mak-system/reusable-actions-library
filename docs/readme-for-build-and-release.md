# 🚀 Build & Release Java Application Workflow

**Repository:** `.github/workflows/build-and-release-v3.yml`  


---

## 📌 What Does This Do?

This workflow **automatically** takes your Java code → compiles it → packages it into a Windows installer → publishes it → and tells your team. No manual steps needed after you hit "Create Release."

**The Pipeline Flow:**
```
Code Push → Trigger Release → Build JAR → Check Setup Files → 
Create .exe Installer → Upload to Release → Notify Team ✅
```

---

## ⚡ Quick Start (Copy-Paste These Steps)

### Step 1: Add Your Teams Webhook (One-Time Setup)
1. Open your **GitHub repo** → Settings
2. Secrets and variables → **Actions**
3. Click **New repository secret**
4. Name: `TEAMS_WEBHOOK_URL`
5. Value: [Get this from your Teams channel settings]

**How to get Teams webhook:**
- Go to your Teams channel
- Click **...** (more options) → Connectors
- Search "Incoming Webhook" → Configure
- Create → Copy the URL → Paste it as secret

### Step 2: Create a Release (This Triggers Everything)
```bash
git tag v1.0.0
git push origin v1.0.0
```

Then go to GitHub → Releases → Create Release from tag

**Done!** Workflow runs automatically. Check the Actions tab to watch it build.

### Step 3: Watch It Run
- Go to **Actions** tab in your repo
- Click the running workflow
- Watch each job complete in real-time
- Success = your .exe is ready in the Release assets

---

## 🎛️ Manual Testing (If You Want to Build Without Creating a Release)

1. Go to **Actions** → **Build & Release Java App**
2. Click **Run workflow**
3. (Optional) Change any of these:
   - **Java version:** `17`, `11`, or `21`
   - **Java distribution:** `temurin` (default), `zulu`, or `corretto`
   - **Gradle task:** `jar`, `build`, or `shadowJar`
4. Click **Run workflow**
5. Monitor in the Actions tab

---

## 📋 What You Need (Prerequisites)

Your repo **must have:**
- ✅ `build.gradle` or `build.gradle.kts` (Gradle config file)
- ✅ `.iss` file (Inno Setup script for the Windows installer)
- ✅ `TEAMS_WEBHOOK_URL` secret configured

**Missing something?** See "Troubleshooting" below.

---

## 🔄 How It Works (The 5 Stages)

### Stage 1️⃣: Build JAR (2-5 minutes)
**What:** Compiles your Java code using Gradle  
**Output:** A `.jar` file ready to package  
**Fails if:** `build.gradle` is broken or missing

### Stage 2️⃣: Validation (1 minute)
**What:** Checks that:
- Your `.iss` setup script exists
- The JAR was actually built
- Everything is in place before installer creation

**Fails if:** `.iss` file missing OR jar_cache_key is empty

### Stage 3️⃣: Build Installer (3-5 minutes)
**What:** Takes the JAR and wraps it in a Windows `.exe` using your Inno Setup config  
**Output:** `Setup-v1.0.0.exe` (ready for users to download)  
**Fails if:** `.iss` file has syntax errors

### Stage 4️⃣: Upload to Release (1 minute)
**What:** Takes the `.exe` and attaches it to your GitHub Release  
**Result:** Users can now download it from the Releases page

### Stage 5️⃣: Notify Team (30 seconds)
**What:** Sends a Microsoft Teams message saying "✅ Build succeeded!" or "🚨 Build failed!"  
**Where:** Your Teams channel (the one you configured the webhook for)

---

## 🔧 Customization Examples

### Example 1: Build with Java 21
```
Manual Trigger → Set java_version to "21" → Run
```

### Example 2: Create Fat JAR (All dependencies inside)
```
Manual Trigger → Set gradle_task to "shadowJar" → Run
```

### Example 3: Use Corretto Java
```
Manual Trigger → Set java_distribution to "corretto" → Run
```

---

## ❌ Troubleshooting

### Problem: "JAR cache key is empty"
**Why it happens:** Build failed  
**Fix:**
1. Open the workflow run → Click `build_jar` job
2. Read the error message (usually a Gradle error)
3. Fix your code or `build.gradle`
4. Try again

---

### Problem: ".iss setup script not found"
**Why it happens:** No `.iss` file in your repo  
**Fix:**
1. Create an Inno Setup script (`.iss` file)
2. Save it in repo root or a subdirectory
3. Push to GitHub
4. Try workflow again

**Don't have an `.iss` file?**  
Ask Platform Engineering team for a template or [check Inno Setup docs](https://jrsoftware.org/isinfo.php)

---

### Problem: "Teams webhook URL is empty"
**Why it happens:** `TEAMS_WEBHOOK_URL` secret not set  
**Fix:**
1. Repo Settings → Secrets and variables → Actions
2. Create secret named `TEAMS_WEBHOOK_URL`
3. Paste your Teams webhook URL
4. Try workflow again

---

### Problem: Workflow stuck/won't finish
**Why it happens:** Usually Gradle downloading dependencies (slow on first build)  
**What to do:**
1. Check runner logs for "downloading"
2. Wait 5-10 minutes (first builds are slower)
3. If still stuck after 15 min, cancel and retry

---

## 📊 Real-World Example: Release v2.5.0

**You do:**
```bash
git tag v2.5.0
git push origin v2.5.0
# Go to GitHub and create release from tag
```

**Workflow does automatically:**
1. ✅ Builds `app.jar` using Java 17
2. ✅ Finds your `setup.iss` script
3. ✅ Creates `Setup-v2.5.0.exe`
4. ✅ Uploads to Release assets
5. ✅ Sends Teams message: "✅ Build succeeded! Release v2.5.0 ready"

**Your users do:**
- Go to Releases page
- Download `Setup-v2.5.0.exe`
- Run installer → App installed

**Total time:** ~12-15 minutes, zero manual steps.

---

## 📞 Support & Questions

| Question | Answer |
|----------|--------|
| Can I use a different Java version? | Yes, override `java_version` to 11 or 21 |
| What if I don't want Teams notifications? | Remove `notify_success` & `notify_failure` jobs (not recommended) |
| Can I schedule builds? | Currently no. Contact Platform Engineering to add cron triggers |
| Can I use a different build tool? | Workflow currently uses Gradle. Contact Platform Eng for Maven support |

---

## 🔗 Related Resources

- [Workflow YAML File](.github/workflows/build-and-release-v3.yml)
- [Inno Setup Documentation](https://jrsoftware.org/isinfo.php)
- [Gradle Docs](https://docs.gradle.org)
- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Reusable Actions Library](https://github.com/m-nikolovska-mak-system/reusable-actions-library)

---

## 📝 Checklists

### Before Your First Release ✓
- [ ] `build.gradle` or `build.gradle.kts` committed
- [ ] `.iss` Inno Setup file in repo
- [ ] `TEAMS_WEBHOOK_URL` secret added
- [ ] Gradle wrapper (`.gradle/wrapper/`) committed
- [ ] `.gitignore` doesn't exclude build files

### Before Each Release ✓
- [ ] Code is merged to main/master
- [ ] Version bumped in `build.gradle`
- [ ] Tag created: `git tag v1.2.3`
- [ ] Tag pushed: `git push origin v1.2.3`
- [ ] GitHub Release created from tag

---

**Questions?** Slack #platform-engineering or check the [troubleshooting section](#-troubleshooting)
