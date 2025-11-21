# Build & Release Java Application Workflow

## Overview

This workflow automates the complete build, validation, and release pipeline for Java applications. It orchestrates compilation, Windows installer creation, artifact publishing, and team notifications—all triggered automatically on release creation or manual dispatch.

**Workflow Location:** `.github/workflows/build-and-release-v3.yml`  
**Status:** Enterprise-Grade | Production Ready  
**Maintainer:** Platform Engineering Team

---

## Quick Start

### For Development Teams

1. **Automatic Release Publishing**
   - Create a GitHub release in your repository
   - Workflow triggers automatically and publishes artifacts to the release

2. **Manual Build Testing**
   - Go to **Actions** → **Build & Release Java App**
   - Click **Run workflow**
   - (Optional) Override Java version or gradle task
   - Monitor execution in real-time

### For Platform/DevOps Teams

- This workflow is production-ready and requires no additional setup beyond secret configuration
- All reusable components are maintained in the centralized `reusable-actions-library` repository

---

## Features

| Feature | Description |
|---------|-------------|
| **Multi-Stage Pipeline** | Build → Validate → Package → Upload → Notify |
| **Concurrent Build Prevention** | Prevents overlapping runs for the same release |
| **Input Validation** | Catches build failures before installer creation |
| **Windows Installer Support** | Automatically packages JAR into `.exe` installer |
| **Team Notifications** | Sends success/failure alerts to Microsoft Teams |
| **Flexible Parameters** | Override Java version, distribution, or Gradle task |

---

## Prerequisites

### Repository Requirements

- Java application with `build.gradle` or `build.gradle.kts`
- Inno Setup script (`.iss` file) in repository root or subdirectory
- GitHub release capability enabled

### Secrets Configuration

Add the following secret to your repository (Settings → Secrets and variables → Actions):

| Secret Name | Description | Example |
|------------|-------------|---------|
| `TEAMS_WEBHOOK_URL` | Microsoft Teams incoming webhook for notifications | `https://outlook.webhook.office.com/webhookb2/...` |

**How to set up Teams webhook:**
1. In Microsoft Teams, go to channel settings
2. Select "Connectors" → "Configure"
3. Search for "Incoming Webhook" → "Configure"
4. Copy the webhook URL
5. Add to repository secrets as `TEAMS_WEBHOOK_URL`

---

## Workflow Inputs

When triggering via **workflow_dispatch** (manual trigger), you can customize:

| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `java_version` | string | `17` | Java version for compilation (e.g., 11, 17, 21) |
| `java_distribution` | string | `temurin` | Java distribution (temurin, zulu, corretto) |
| `gradle_task` | string | `jar` | Gradle task to execute (jar, build, shadowJar) |

**Example Override Scenario:**
- Default: Java 17 + Temurin + jar task
- Override: Java 21 + Temurin + shadowJar (for fat JARs)

---

## Pipeline Stages

### Stage 1: Build JAR
**Job:** `build_jar`  
**Duration:** ~2-5 minutes  
**Uses:** `reusable-actions-library/build-jar.yml`

Compiles your Java application using Gradle. Produces a JAR artifact cached for downstream jobs.

### Stage 2: Validation
**Jobs:** `detect_iss`, `validate_inputs`  
**Duration:** ~1 minute  
**Uses:** `reusable-actions-library/detect-setup-script.yml`

- Scans for Inno Setup (`.iss`) configuration
- Validates JAR build output exists and contains cache key
- Fails fast if critical artifacts missing

### Stage 3: Build Installer
**Job:** `build_installer`  
**Duration:** ~3-5 minutes  
**Uses:** `reusable-actions-library/build-installer.yml`

Creates Windows `.exe` installer from JAR using Inno Setup configuration. Output: `Setup-<VERSION>.exe`

### Stage 4: Upload Release
**Job:** `upload_release`  
**Duration:** ~1 minute  
**Uses:** `reusable-actions-library/upload-release.yml`

Publishes installer artifact to GitHub Release. Creates downloadable asset for end users.

### Stage 5: Notifications
**Jobs:** `notify_success`, `notify_failure`  
**Duration:** ~30 seconds  
**Uses:** `reusable-actions-library/teams-notifier.yml`

Sends Microsoft Teams notification with:
- Build status (✅ success or 🚨 failure)
- Release link or logs link
- Action items for the team

---

## Troubleshooting

### ❌ "JAR cache key is empty"
**Cause:** Build failed or didn't produce output  
**Solution:** 
1. Check build logs in `build_jar` job
2. Verify `build.gradle` exists and is valid
3. Ensure Gradle wrapper is committed to repo

### ❌ ".iss setup script not found"
**Cause:** No Inno Setup configuration in repository  
**Solution:**
1. Add `.iss` file to repository root
2. Ensure file follows Inno Setup syntax
3. Run `detect_iss` job logs for pattern matching details

### ❌ "Teams webhook URL is empty"
**Cause:** `TEAMS_WEBHOOK_URL` secret not configured  
**Solution:**
1. Go to repo Settings → Secrets and variables → Actions
2. Create new repository secret named `TEAMS_WEBHOOK_URL`
3. Paste Microsoft Teams incoming webhook URL

### ❌ Workflow stuck or timed out
**Cause:** Gradle dependency resolution or build is slow  
**Solution:**
1. Check if Gradle is downloading dependencies (first build slower)
2. Verify no deadlocks in Gradle configuration
3. Check runner logs for resource constraints

---

## Advanced Usage

### Custom Gradle Tasks

Override `gradle_task` to run specialized builds:

```
gradle_task: shadowJar    # For fat/uber JARs
gradle_task: build        # Run full build suite
gradle_task: nativeImage  # For GraalVM native compilation
```

### Monitoring & Observability

- **Real-time logs:** Actions tab → Select workflow run → View each job
- **Artifact inspection:** Actions tab → Download artifacts from successful runs
- **Failure diagnosis:** Check individual job logs for error messages
- **Team alerts:** Monitor Teams channel for notifications


---

## FAQ

**Q: Can I use a different Java distribution?**  
A: Yes, override `java_distribution` with `corretto`, `zulu`, or other distributions supported by setup-java action.

**Q: What if I don't have an .iss file?**  
A: The workflow requires Windows installer setup. Contact Platform Engineering to discuss alternatives.

**Q: Can I run this on a schedule?**  
A: Currently supports `workflow_dispatch` (manual) and `release` (automatic) triggers. Contact platform-engineering for scheduled builds.

**Q: How do I disable Teams notifications?**  
A: Modify workflow to remove `notify_success` and `notify_failure` jobs, or set secret to empty string (not recommended).

---

## Related Resources

- [Inno Setup Documentation](https://jrsoftware.org/isinfo.php)
- [Gradle Documentation](https://docs.gradle.org)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Reusable Actions Library](https://github.com/m-nikolovska-mak-system/reusable-actions-library)
