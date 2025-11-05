# 📦 Build Installer Workflow

This workflow builds a Windows installer (`.exe`) from a JAR file using **Inno Setup**. It is designed to be reusable across repositories.

---

## 🛠 Workflow Path

`.github/workflows/build-installer.yml`

---

## ⚡ Inputs

| Input | Required | Type | Description |
|-------|----------|------|-------------|
| `jar_cache_key` | ✅ | string | A key to restore/cache the JAR file from a previous build. Example: `app-jar-${{ github.event.release.tag_name }}` |
| `release_tag` | ❌ | string | Git tag or branch to checkout. Default: `main`. |
| `setup_script` | ✅ | string | Path to the Inno Setup script (`.iss`) used to build the installer. |
| `app_name` | ✅ | string | Name of your application (used in installer and folder names). |
| `app_version` | ✅ | string | Version of your application (displayed in installer). |
| `output_name` | ✅ | string | Base name for the generated installer (`output/{output_name}.exe`). |

---

## 🏗 Workflow Steps

1. **Checkout repository**  
   Checks out the repo at the specified release tag.

2. **Restore cached JAR**  
   Uses `actions/cache` to restore the previously built JAR file for faster builds.

3. **Validate JAR presence**  
   Ensures a JAR exists before attempting the installer build.

4. **Get JAR filename**  
   Dynamically finds the first JAR in `build/libs` and stores the filename in an output variable.

5. **Install Inno Setup**  
   Installs Inno Setup via Chocolatey on Windows runners.

6. **Build the installer**  
   Runs `ISCC.exe` with the provided `.iss` script and parameters (`AppName`, `AppVersion`, `JarFileName`, `OutputBaseName`).

7. **Upload artifact**  
   Uploads the generated `.exe` installer as a workflow artifact for download.

---

## 🔗 Example Usage

```yaml
jobs:
  build_installer:
    uses: your-org/reusable-actions-library/.github/workflows/build-installer.yml@main
    with:
      jar_cache_key: 'app-jar-${{ github.event.release.tag_name }}'
      release_tag: ${{ github.event.release.tag_name }}
      setup_script: '.github/scripts/setup.iss'
      app_name: 'Template Designer'
      app_version: ${{ github.event.release.tag_name }}
      output_name: 'TemplateDesignerSetup'
