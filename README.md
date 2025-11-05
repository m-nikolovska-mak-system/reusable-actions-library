🔄 Reusable GitHub Actions Workflows
This repository provides reusable GitHub Actions workflows for automating:

✅ Detecting file changes between release tags  
✅ Sending Microsoft Teams Adaptive Card notifications  
✅ Building Windows installers with Inno Setup  

These workflows help engineering teams stay informed about critical changes and streamline release processes.

📦 Available Workflows

| Workflow | Description | Docs |
|----------|------------|------|
| check-for-file-changes.yml | Detects if specified files changed between Git tags | – |
| send-teams-notification.yml | Sends customizable Microsoft Teams Adaptive Card notifications | Setup Guide → |
| build-installer.yml | Builds a Windows installer from a JAR using Inno Setup | Setup Guide → |

✅ Example Combined Usage – Build Installer on Release

```yaml
name: Build Installer for MyApp

on:
  release:
    types: [published]
  workflow_dispatch:

permissions:
  contents: read

jobs:
  build_installer:
    uses: your-org/reusable-actions-library/.github/workflows/build-installer.yml@main
    with:
      jar_cache_key: "jar-${{ github.event.release.tag_name }}"
      release_tag: ${{ github.event.release.tag_name }}
      setup_script: "installer.iss"
      app_name: "MyApp"
      app_version: ${{ github.event.release.tag_name }}
      output_name: "Setup-${{ github.event.release.tag_name }}"
