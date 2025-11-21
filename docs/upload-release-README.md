# 📤 Upload Release Asset Reusable Workflow

**File:** `.github/workflows/upload-release.yml`  
**Type:** Reusable Workflow (Called by other workflows)  
**Purpose:** Attaches built files (like `.exe` installers) to GitHub Releases so users can download them  

---

## 🎯 What This Does

Takes a file that was built by another workflow and attaches it to your GitHub Release. Users then see it on the Releases page and can download it.

**What you give it:**
- Git tag/release name
- Artifact name (from previous workflow)

**What you get back:**
- ✅ File attached to GitHub Release
- ✅ Public download link for users

**Visual:**
```
build-installer creates Setup.exe
        ↓
upload-release takes Setup.exe
        ↓
Attaches to GitHub Release
        ↓
Users see it on Releases page ✅
```

---

## 📥 Inputs (What You Customize)

| Input | Type | Required? | Default | What It Does | Example |
|-------|------|-----------|---------|-------------|---------|
| `tag_name` | string | ✅ **YES** | — | Which release to attach to | `v1.0.0`, `v2.5.0` |
| `artifact_name` | string | ✅ **YES** | — | Name of artifact from previous job | `windows-installer` |
| `file_pattern` | string | No | `*.exe` | Which files to upload (glob) | `*.exe`, `*.zip`, `Setup-*.exe` |

---

## 📤 Outputs (What You Get Back)

This workflow doesn't produce outputs, but it creates a side effect:

**Side Effect:**
- Files are now attached to your GitHub Release
- Users can download from `github.com/your-repo/releases/tag/v1.0.0`

---

## 💡 Usage Examples

### Example 1: Basic Release Upload

```yaml
jobs:
  build_installer:
    uses: reusable-actions-library/.github/workflows/build-installer.yml@main
    with:
      # ... build inputs ...
      output_name: Setup-1.0.0

  upload:
    needs: build_installer
    uses: reusable-actions-library/.github/workflows/upload-release.yml@main
    with:
      tag_name: v1.0.0
      artifact_name: windows-installer
```

**What happens:**
- ✅ build-installer creates `Setup-1.0.0.exe`
- ✅ Stores it as artifact named `windows-installer`
- ✅ upload-release downloads that artifact
- ✅ Attaches to GitHub Release `v1.0.0`

---

### Example 2: With Dynamic Tag Name

```yaml
upload:
  needs: build_installer
  uses: reusable-actions-library/.github/workflows/upload-release.yml@main
  with:
    tag_name: ${{ github.event.release.tag_name }}  # Get from release event
    artifact_name: windows-installer
```

**Use case:** Triggered by release creation, automatically uses that release's tag

---

### Example 3: Upload Multiple Files

```yaml
upload:
  needs: build_installer
  uses: reusable-actions-library/.github/workflows/upload-release.yml@main
  with:
    tag_name: v1.0.0
    artifact_name: build-outputs
    file_pattern: "Setup-*.exe"  # Upload all Setup files
```

---

### Example 4: Upload ZIP Archives

```yaml
upload:
  needs: package_job
  uses: reusable-actions-library/.github/workflows/upload-release.yml@main
  with:
    tag_name: v2.0.0
    artifact_name: release-package
    file_pattern: "*.zip"
```

---

## 🔍 How It Works (Step-by-Step)

1. **Gets job dependencies** (waits for build_installer to finish)
2. **Downloads the artifact** from previous job (e.g., `windows-installer`)
3. **Validates directory exists** (safety check)
4. **Lists files** (shows what was downloaded)
5. **Matches file pattern** (filters to `*.exe` or your pattern)
6. **Uploads to GitHub Release** using the tag name
7. **Summary report** shows what was uploaded

---

## ❌ Troubleshooting

### Problem: "release-assets directory missing"

**Why it happens:**
- Artifact download failed
- Previous job (`needs:`) didn't complete
- Artifact name is wrong

**How to fix:**
1. Check `artifact_name` matches the build job's output name
2. Verify previous job (`needs: build_installer`) succeeded
3. Look at artifact details in Actions tab

**Debug:**
```yaml
- name: List artifacts
  run: ls -la
```

---

### Problem: "No files matching pattern"

**Why it happens:**
- `file_pattern` doesn't match any files
- Files were built but with different names
- Previous job failed silently

**How to fix:**
1. Verify the pattern is correct: `*.exe`, `Setup-*.exe`, `*.zip`
2. Check what the build job actually created
3. List files from previous job in Actions artifacts tab
4. If needed, update `file_pattern` to match actual names

**Common patterns:**
- `*.exe` - all `.exe` files
- `Setup-*.exe` - files starting with "Setup-"
- `*.zip` - all ZIP archives
- `app.*` - files starting with "app."

---

### Problem: "Upload to GitHub Release failed"

**Why it happens:**
- `tag_name` doesn't exist as a GitHub release
- Release permissions not granted
- Network error

**How to fix:**
1. Verify the tag exists: `git tag -l | grep v1.0.0`
2. Verify GitHub Release was created (not just git tag)
3. Check repo Settings → Actions → Permissions (needs write access)
4. Retry the job (temporary network glitch)

**Correct workflow:**
```bash
git tag v1.0.0
git push origin v1.0.0
# Go to GitHub → Releases → Create Release from tag
# Then trigger workflow
```

---

### Problem: "GITHUB_TOKEN is empty"

**Why it happens:**
- Workflow permissions not configured
- Using wrong secret name

**How to fix:**
1. Workflow uses default `secrets.GITHUB_TOKEN` (automatic)
2. No configuration needed if using GitHub.com
3. If self-hosted, verify runner has token access
4. Don't pass `GITHUB_TOKEN` in inputs (it's automatic)

---

### Problem: File already exists on release

**Why it happens:**
- Uploaded same file twice
- Ran workflow twice for same version
- File overwrite is enabled

**How to fix:**
1. Check if this is intended (workflow has `overwrite_files: true`)
2. If you want to keep old files, disable overwrites
3. Use unique filenames per build

---

## 📊 Real Example

Complete pipeline with upload:

```yaml
name: Build and Release

on:
  release:
    types: [created]

jobs:
  build_jar:
    uses: reusable-actions-library/.github/workflows/build-jar.yml@main
    with:
      release_tag: ${{ github.event.release.tag_name }}

  build_installer:
    needs: build_jar
    uses: reusable-actions-library/.github/workflows/build-installer.yml@main
    with:
      jar_cache_key: ${{ needs.build_jar.outputs.jar_cache_key }}
      app_version: ${{ github.event.release.tag_name }}
      output_name: Setup-${{ github.event.release.tag_name }}

  upload_release:
    needs: build_installer
    uses: reusable-actions-library/.github/workflows/upload-release.yml@main
    with:
      tag_name: ${{ github.event.release.tag_name }}
      artifact_name: windows-installer
```

**Timeline:**
```
User creates Release v1.0.0
         ↓
build_jar job runs (compiles Java)
         ↓
build_installer job runs (packages .exe)
         ↓
upload_release job runs (attaches to Release)
         ↓
Users see Setup-v1.0.0.exe on Release page ✅
```

---

## 🎯 When to Use This

✅ **Use this workflow when you want to:**
- Attach compiled binaries to releases
- Give users downloadable files
- Auto-publish built artifacts
- Keep releases organized with assets

❌ **Don't use this workflow for:**
- Uploading documentation (use GitHub Pages)
- Storing build logs (they're already in Actions)
- Publishing to package managers (use separate workflows)

---

## 📝 GitHub Release Concepts

### Release vs Tag
- **Tag:** Git label (e.g., `v1.0.0`)
- **Release:** GitHub feature on top of tag (includes description, assets, downloads)

### Assets
- Files attached to a release
- Users download from "Releases" page
- Can have multiple assets per release

### Example Release Page
```
Release v1.0.0
├── Description
├── Release Notes
└── Assets (downloads)
    ├── Setup-v1.0.0.exe (↓ download)
    ├── app-v1.0.0.zip
    └── LICENSE.txt
```

---

## ✅ Checklist Before Running

- [ ] GitHub Release exists (not just git tag)
- [ ] `tag_name` matches release tag exactly (case-sensitive)
- [ ] `artifact_name` matches build job output
- [ ] Previous job completed successfully
- [ ] Files exist in artifact (check Actions tab)
- [ ] Repository has write permissions enabled
- [ ] `file_pattern` matches actual built files

---

## 🤔 FAQ

**Q: Can I upload to an old release?**  
A: Yes, set `tag_name` to any existing release tag (e.g., `v1.0.0`).

**Q: Can I upload multiple files?**  
A: Yes, use glob patterns: `file_pattern: "*.exe"` uploads all `.exe` files.

**Q: What if the release doesn't exist yet?**  
A: Create the release first, then run upload. Or use `gh release create` first.

**Q: Can I upload directly from another workflow?**  
A: Yes, if both jobs are in same workflow. Use `needs:` to create dependency.

**Q: Can I upload to multiple releases?**  
A: Only one at a time. Run workflow multiple times for different tags.

**Q: Does this overwrite existing files?**  
A: Yes, this workflow has `overwrite_files: true` by default.

**Q: Can I add release notes automatically?**  
A: Not with this workflow. Use `gh release edit` command for that.

---

## 🔗 Related Docs

- [GitHub Releases Documentation](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases)
- [Build Installer Workflow](./build-installer-README.md)
- [Build JAR Workflow](./build-jar-README.md)
- [Main Build & Release Workflow](../build-and-release-v3.md)
- [GitHub Actions Artifacts](https://docs.github.com/en/actions/using-workflows/storing-workflow-data-as-artifacts)

---

## 💡 Pro Tips

**Tip 1: Create releases from command line**
```bash
# Create tag
git tag v1.0.0
git push origin v1.0.0

# Create release (from tag)
gh release create v1.0.0 --title "Version 1.0.0" --notes "Release notes here"
```

**Tip 2: Test locally before automation**
```bash
# Verify release exists
gh release list

# View release assets
gh release view v1.0.0
```

**Tip 3: Use semantic versioning**
```
v1.0.0  ← Major.Minor.Patch
```

---

**Questions?** Slack #platform-engineering or open an issue in the reusable-actions-library repo
