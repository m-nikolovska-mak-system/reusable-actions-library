# 🪟 Build Windows Installer Reusable Workflow

**File:** `.github/workflows/build-installer.yml`  
**Type:** Reusable Workflow (Called by other workflows)  
**Purpose:** Packages a JAR into a Windows `.exe` installer using Inno Setup  
**Environment:** Windows runner (builds `.exe` files)  

---

## 🎯 What This Does (Plain English)

Takes a compiled JAR file and wraps it in a Windows installer (`.exe`) that end users can download and run.

**What you give it:**
- Path to the JAR file
- Inno Setup script (`.iss` file)
- App name and version

**What you get back:**
- ✅ `Setup-v1.0.0.exe` (ready to download)
- ✅ Installer name and artifact details

---

## 📥 Inputs (What You Customize)

| Input | Type | Required? | Default | What It Does | Example |
|-------|------|-----------|---------|-------------|---------|
| `jar_cache_key` | string | ✅ **YES** | — | The cache key from build-jar workflow | `jar-abc123def` |
| `jar_path` | string | No | `build/libs/*.jar` | Where the JAR is located | `build/libs/myapp.jar` |
| `release_tag` | string | No | `main` | Git ref to checkout | `main`, `v1.0.0` |
| `setup_script` | string | ✅ **YES** | — | Path to your `.iss` file | `setup.iss`, `installer/app.iss` |
| `app_name` | string | ✅ **YES** | — | Display name in installer | `My Application` |
| `app_version` | string | ✅ **YES** | — | Version shown to users | `1.0.0`, `v1.0.0` |
| `output_name` | string | ✅ **YES** | — | Installer filename (no `.exe`) | `Setup-v1.0.0` |
| `installer_icon` | string | No | (empty) | Path to `.ico` file | `assets/app-icon.ico` |
| `inno_setup_version` | string | No | `6` | Inno Setup version | `6`, `6.2.2` |

---

## 📤 Outputs (What You Get Back)

| Output | What It Contains | Example |
|--------|-----------------|---------|
| `installer_artifact_name` | Name of uploaded artifact | `windows-installer` |
| `installer_filename` | Actual `.exe` filename | `Setup-v1.0.0.exe` |

---

## 💡 Usage Examples

### Example 1: Basic Installer Build

```yaml
jobs:
  build_jar:
    uses: reusable-actions-library/.github/workflows/build-jar.yml@main
    with:
      release_tag: main

  build_installer:
    needs: build_jar
    uses: reusable-actions-library/.github/workflows/build-installer.yml@main
    with:
      jar_cache_key: ${{ needs.build_jar.outputs.jar_cache_key }}
      setup_script: setup.iss
      app_name: My Application
      app_version: "1.0.0"
      output_name: Setup-1.0.0
```

**What happens:**
- ✅ Gets JAR from cache using key from build_jar
- ✅ Reads `setup.iss` file from repo
- ✅ Builds `Setup-1.0.0.exe`
- ✅ Uploads to artifacts

---

### Example 2: With Custom Icon

```yaml
build_installer:
  needs: build_jar
  uses: reusable-actions-library/.github/workflows/build-installer.yml@main
  with:
    jar_cache_key: ${{ needs.build_jar.outputs.jar_cache_key }}
    setup_script: installer/setup.iss
    app_name: My Cool App
    app_version: ${{ github.event.release.tag_name }}  # e.g., v2.5.0
    output_name: Setup-${{ github.event.release.tag_name }}
    installer_icon: assets/app-icon.ico
```

---

### Example 3: From Release Tag

```yaml
build_installer:
  needs: build_jar
  uses: reusable-actions-library/.github/workflows/build-installer.yml@main
  with:
    release_tag: v1.5.0
    jar_cache_key: ${{ needs.build_jar.outputs.jar_cache_key }}
    setup_script: setup.iss
    app_name: Enterprise App
    app_version: 1.5.0
    output_name: Setup-1.5.0
    inno_setup_version: "6.2.2"
```

---

## 📋 Prerequisites

Your repo **MUST have:**

1. **`.iss` file** (Inno Setup script)
   ```
   Location: repo root or subdirectory
   Example: setup.iss, installer/setup.iss
   ```

2. **Gradle JAR** (from build-jar workflow)
   ```
   The jar_cache_key must match output from build-jar
   ```

3. **(Optional) Icon file** (`.ico` format)
   ```
   Location: anywhere in repo (e.g., assets/icon.ico)
   Size: 32x32 or 256x256 recommended
   ```

---

## 🔍 What Happens Inside (Step-by-Step)

1. **Checkout repo** from specified Git ref
2. **Restore JAR from cache** using the cache key
3. **Verify JAR exists** (safety check)
4. **Check setup script** exists and is valid
5. **Install Inno Setup** compiler (if not already there)
6. **Validate Inno Setup** compiler is working
7. **Create output directory** for the installer
8. **Run Inno Setup compiler** with your parameters
9. **Verify `.exe` was created** successfully
10. **Upload `.exe` as artifact** (for later download)
11. **Summary report** shows what was built

---

## ❌ Troubleshooting

### Problem: "Setup script not found"

**Why it happens:**
- `.iss` file path is wrong
- File doesn't exist in repo

**How to fix:**
1. Check the `setup_script` path you passed
2. Verify file exists: `ls -la setup.iss`
3. Make sure it's committed to Git: `git add setup.iss && git commit`
4. Path is case-sensitive on Linux runners

---

### Problem: "No JAR files found after cache restore"

**Why it happens:**
- `jar_cache_key` is incorrect
- build-jar workflow failed
- Cache expired (30+ days old)

**How to fix:**
1. Verify `jar_cache_key` matches build-jar output (exactly!)
2. Check build-jar job completed successfully
3. Look at build-jar logs for errors
4. Make sure jobs have `needs:` dependency set

**Debug:**
```yaml
- name: Debug JAR
  run: |
    ls -la build/libs/
    echo "Cache key: ${{ inputs.jar_cache_key }}"
```

---

### Problem: "ISCC.exe not found"

**Why it happens:**
- Inno Setup didn't install correctly
- Wrong version specified
- Installation location differs

**How to fix:**
1. Check `inno_setup_version` is valid (try `6` or `6.2.2`)
2. Workflow tries to auto-install Inno Setup
3. If install fails, check runner has Chocolatey installed
4. Try specifying exact version: `inno_setup_version: "6.2.2"`

---

### Problem: ".iss script has errors"

**Why it happens:**
- Syntax error in your Inno Setup script
- Missing variables or paths
- Incompatible with Inno Setup version

**How to fix:**
1. Test the `.iss` file locally with Inno Setup IDE
2. Check that variable names match what workflow passes:
   - `{#AppName}` 
   - `{#AppVersion}`
   - `{#JarFileName}`
   - `{#OutputBaseName}`
3. Validate paths are correct (JAR location, output dir)
4. Add to `additional_gradle_args` to see compilation details

**Example valid `.iss` section:**
```ini
[Setup]
AppName={#AppName}
AppVersion={#AppVersion}
DefaultDirName={pf}\{#AppName}
DefaultGroupName={#AppName}
OutputDir=output
OutputBaseFilename={#OutputBaseName}

[Files]
Source: "build\libs\{#JarFileName}"; DestDir: "{app}"
```

---

### Problem: Installer is very large

**Why it happens:**
- JAR includes all dependencies (normal!)
- Inno Setup added compression overhead
- Using a "fat JAR" from shadowJar

**How to fix:**
- This is normal, not an error
- Large installers are expected for Java apps (JVM + dependencies)
- Typical range: 50-200 MB

---

## 📝 Sample `.iss` File (Reference)

Here's a minimal working Inno Setup script:

```ini
[Setup]
AppName={#AppName}
AppVersion={#AppVersion}
DefaultDirName={pf}\{#AppName}
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
OutputDir=output
OutputBaseFilename={#OutputBaseName}
Compression=lzma
SolidCompression=yes

[Files]
Source: "build\libs\{#JarFileName}"; DestDir: "{app}"

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#JarFileName}"
Name: "{group}\Uninstall {#AppName}"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\{#JarFileName}"; Flags: shellexec; Description: "Launch {#AppName}"
```

**Key variables passed by workflow:**
- `{#AppName}` = `app_name` input
- `{#AppVersion}` = `app_version` input
- `{#JarFileName}` = JAR filename from build
- `{#OutputBaseName}` = `output_name` input

---

## 🎛️ Inno Setup Basics

| Concept | Purpose | Example |
|---------|---------|---------|
| `[Setup]` | General installer settings | AppName, Version, OutputDir |
| `[Files]` | What files to include | JAR, config, resources |
| `[Icons]` | Start menu shortcuts | App launcher, uninstall |
| `[Run]` | Post-install commands | Launch app, run setup |
| `{pf}` | Program Files directory | `C:\Program Files\` |
| `{#VarName}` | Variables passed by workflow | `{#AppName}` |

---

## ✅ Checklist Before Running

- [ ] `.iss` file exists in repo
- [ ] `.iss` file is valid Inno Setup syntax
- [ ] `setup_script` path matches actual file location
- [ ] `app_name` and `app_version` are set
- [ ] `jar_cache_key` matches build-jar output
- [ ] (Optional) Icon file exists and is `.ico` format
- [ ] All paths use forward slashes `/` or proper Windows backslashes

---

## 🤔 FAQ

**Q: Can I customize the installer appearance?**  
A: Yes, edit your `.iss` file. See [Inno Setup Documentation](https://jrsoftware.org/isinfo.php).

**Q: Can I run scripts after installation?**  
A: Yes, add `[Run]` section to `.iss` file.

**Q: Why is the installer so large?**  
A: Java apps need the JVM + all dependencies inside. 50-200 MB is typical.

**Q: Can I add a license agreement?**  
A: Yes, add `[Files]` entry for license, then `LicenseFile=` in `[Setup]`.

**Q: Can I split installer into multiple parts?**  
A: Not with this workflow. Contact Platform Eng.

**Q: Can I code-sign the `.exe`?**  
A: Not included in this workflow. Contact Platform Eng for signing support.

---

## 🔗 Related Docs

- [Inno Setup Documentation](https://jrsoftware.org/isinfo.php)
- [Build JAR Workflow](./build-jar-README.md)
- [Upload Release Workflow](./upload-release-README.md)
- [Main Build & Release Workflow](../build-and-release-v3.md)
- [GitHub Actions Artifacts](https://docs.github.com/en/actions/using-workflows/storing-workflow-data-as-artifacts)

---

**Questions?** Slack #platform-engineering or open an issue in the reusable-actions-library repo
