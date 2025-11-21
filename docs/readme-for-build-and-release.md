# 🚀 Build & Release Java Application Workflow

**Location:** `.github/workflows/build-and-release-v3.yml`  

---

## 📌 What It Does

Auto-compiles Java → packages Windows installer → uploads to release → notifies team.

```
Release Created → Build JAR → Validate → Build .exe → Upload → Notify ✅
```

---

## ⚡ Quick Start

### Setup (One-Time)
1. Repo Settings → Secrets → New secret
2. Name: `TEAMS_WEBHOOK_URL`
3. Value: [Your Teams webhook from channel settings]

### Create Release
```bash
git tag v1.0.0 && git push origin v1.0.0
# Go to GitHub → Create Release from tag
# Workflow runs automatically ✅
```

### Done!
Check Actions tab to watch it build. Your `.exe` appears in Release assets.

---

## 📋 Prerequisites

Your repo needs:
- ✅ `build.gradle` or `build.gradle.kts`
- ✅ `.iss` Inno Setup file
- ✅ `gradlew` (committed to Git)
- ✅ `TEAMS_WEBHOOK_URL` secret

Missing something? See [Troubleshooting](#troubleshooting).

---

## 🔄 The 5 Stages

| Stage | Duration | What | Fails If |
|-------|----------|------|----------|
| **1. Build JAR** | 2-5m | Compiles Java with Gradle | `build.gradle` broken |
| **2. Detect Setup** | 30s | Finds `.iss` file | No `.iss` found |
| **3. Validate** | 30s | Checks JAR built OK | JAR cache key empty |
| **4. Build Installer** | 3-5m | Packages JAR into `.exe` | `.iss` has errors |
| **5. Upload & Notify** | 2m | Attaches to release + Teams msg | Release doesn't exist |

---

## 🎛️ Manual Testing

Go to **Actions** → **Build & Release Java App** → **Run workflow**

Override (optional):
- `java_version`: 17, 21, 11
- `java_distribution`: temurin, zulu, corretto
- `gradle_task`: jar, shadowJar, build

---

## ❌ Troubleshooting

### "JAR cache key is empty"
→ Build failed. Check `build_jar` job logs for Gradle error. Fix code/build.gradle.

### ".iss setup script not found"
→ No `.iss` file in repo. Create one, commit, push, retry.

### "Teams webhook URL is empty"
→ Secret not configured. Go to Repo Settings → Secrets → Add `TEAMS_WEBHOOK_URL`.

### Workflow stuck
→ First build downloads deps (slow). Wait 5-10 min. Subsequent builds use cache.

### Installer is 100+ MB
→ Normal! Java apps include JVM + dependencies. This is expected.

---

## 📚 Reusable Workflows

Each stage uses a reusable workflow from `reusable-actions-library`. See their docs:

1. **[build-jar README](../docs/build-jar-README.md)** - Compile Java
2. **[detect-setup-script README](../docs/detect-setup-script-README.md)** - Find .iss
3. **[build-installer README](../docs/build-installer-README.md)** - Package .exe
4. **[upload-release README](../upload-release-README.md)** - Upload to release
5. **[teams-notifier README](../docs/teams-notifier-README.md)** - Send Teams msg

---

## 📊 Real Example: Release v2.5.0

```bash
git tag v2.5.0 && git push origin v2.5.0
# Create release on GitHub
```

**Workflow does automatically:**
- ✅ Builds JAR (Java 17)
- ✅ Finds setup.iss
- ✅ Creates Setup-v2.5.0.exe
- ✅ Uploads to Release
- ✅ Sends Teams: "✅ Build Succeeded!"

**Result:** Users download Setup-v2.5.0.exe from Releases page.

**Time:** ~12-15 min, zero manual steps.

---

## 🎯 Customization Examples

| Goal | How |
|------|-----|
| Use Java 21 | Actions → Run workflow → `java_version: 21` |
| Fat JAR (all deps) | Actions → Run workflow → `gradle_task: shadowJar` |
| Use Corretto Java | Actions → Run workflow → `java_distribution: corretto` |

---

## ✅ Checklist Before First Release

- [ ] `build.gradle` or `build.gradle.kts` exists
- [ ] `.iss` file in repo
- [ ] `gradlew` file committed (`ls -la gradlew`)
- [ ] `TEAMS_WEBHOOK_URL` secret added
- [ ] Code builds locally: `./gradlew jar`

---

## 🤔 FAQ

**Can I build without creating a release?**  
Yes, use manual dispatch (Actions → Run workflow).

**What Java versions work?**  
11, 17, 21 (or any supported by GitHub Actions).

**Can I customize the installer?**  
Yes, edit your `.iss` file. See [build-installer docs](../docs/build-installer-README.md).

**Can I skip Teams notifications?**  
Yes, but not recommended. Ask Platform Eng if needed.

**How long does it take?**  
First: 12-15 min. After: 8-10 min (cached).

**Can I use Maven?**  
Not with this workflow. Ask Platform Eng.

---

## 🔗 Links

- [Inno Setup Docs](https://jrsoftware.org/isinfo.php)
- [Gradle Docs](https://docs.gradle.org)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Reusable Actions Library](https://github.com/m-nikolovska-mak-system/reusable-actions-library)

---

**Last Updated:** November 21, 2025 
