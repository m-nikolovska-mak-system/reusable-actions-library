# Build & Release Java Application Workflow

## Table of Contents
- #overview
- #quick-start
- #features
- #prerequisites
- #workflow-inputs
- #pipeline-stages
- [Troubleshooting
- [Advanced Usage](##faq
- [Related Resources](#--

## Overview
This workflow automates the complete build, validation, and release pipeline for Java applications. It:
- Builds a JAR using Gradle
- Packages a Windows installer via Inno Setup
- Publishes artifacts to a GitHub Release
- Sends Microsoft Teams notifications

**Workflow Location:** `.github/workflows/build-and-release-v3.yml`  
**Triggers:**  
- `workflow_dispatch` (manual trigger)  
- `release` (on release creation)  

**Concurrency:** Prevents overlapping runs for the same release tag.  
**Maintainer:** Platform Engineering Team  

---

## Quick Start

### For Development Teams
1. **Automatic Release Publishing**
   - Create a GitHub release → Workflow triggers automatically
   - Installer uploaded to release assets

2. **Manual Build Testing**
   - Go to **Actions → Build & Release Java App**
   - Click **Run workflow**
   - (Optional) Override Java version or Gradle task

### For Platform/DevOps Teams
- No extra setup beyond configuring secrets
- All reusable workflows are maintained in https://github.com/m-nikolovska-mak-system/reusable-actions-library

---

## Features
| Feature | Description |
|---------|-------------|
| **Multi-Stage Pipeline** | Build → Validate → Package → Upload → Notify |
| **Concurrent Build Prevention** | Avoids overlapping runs |
| **Input Validation** | Fails fast if critical artifacts missing |
| **Windows Installer Support** | Packages JAR into `.exe` |
| **Team Notifications** | Success/failure alerts via Teams |
| **Flexible Parameters** | Override Java version, distribution, Gradle task |

---

## Prerequisites
### Repository Requirements
- Java app with `build.gradle` or `build.gradle.kts`
- Inno Setup script (`.iss`) in repo
- GitHub release capability enabled

### Secrets
| Secret Name | Description |
|-------------|-------------|
| `TEAMS_WEBHOOK_URL` | Microsoft Teams webhook URL |

[How to set up Teams webhook →](https://learn.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/add-incomings
| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `java_version` | string | `17` | Java version |
| `java_distribution` | string | `temurin` | Java distribution |
| `gradle_task` | string | `jar` | Gradle task |

---

## Pipeline Stages
| Stage | Job | Reusable Workflow |
|-------|-----|--------------------|
| **Build JAR** | `build_jar` | [build-jar.yml](https://github.com/m-nikolovska-mak-system/reusable-actions-library/.github/workflows/buildetect Setup Script** | `detect_iss` | [detect-setup-script.yml](https://github.com/m-nikolovska-mak-system/reusable-actions-library/.github/workflows/detect-setup-script** | `validate_inputs` | Inline |
| **Build Installer** | `build_installer` | [build-installer.yml](https://github.com/m-nikolovska-mak-system/reusable-actionslows/build-installer.yml |
| **Upload Release** | `upload_release` | [upload-release.yml](https://github.com/m-nikolovska-mak-system/reusable-actions-library/.github/workflows/upload-release.yml/Failure** | `notify_success` / `notify_failure` | [teams-notifier.yml](https://github.com/m-nikolovska-mak-system/reusable-actionsflows/teams-notifier.yml |

---

## Troubleshooting
### ❌ JAR cache key empty
Check `build_jar` logs → Ensure Gradle wrapper exists.

### ❌ .iss script not found
Add `.iss` file → Verify pattern in `detect_iss` job.

### ❌ Teams webhook missing
Add `TEAMS_WEBHOOK_URL` secret.

---

## Advanced Usage
- Override `gradle_task` for `shadowJar` or `nativeImage`.
- Monitor logs in **Actions tab**.
- Download artifacts from successful runs.

---

## FAQ
**Q: Can I use a different Java distribution?**  
Yes, override `java_distribution`.

**Q: What if I don't have an .iss file?**  
Workflow requires installer setup. Contact Platform Engineering.

---

## Related Resources
- [ttps://jrsoftware.org/isinfo.php
- https://docs.gradle.org
- https://docs.github.com/en/actions
- [Reusable Actions Library](https://github.com/m-nikolovskas-library
