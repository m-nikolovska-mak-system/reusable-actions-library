# =====================================================================
# Workflow: Build & Release Java App (v4)
# Purpose : End-to-end pipeline for building a JAR, packaging a Windows
#           installer, publishing it to a GitHub Release, and notifying.
# Triggers: Manual dispatch + Release creation event
# =====================================================================

name: Build & Release Java App (version 3)

on:
  workflow_dispatch:
    inputs:
      java_version:
        description: Java version to use
        required: false
        default: "17"

      java_distribution:
        description: Java distribution (temurin, zulu, etc.)
        required: false
        default: "temurin"

      gradle_task:
        description: Gradle task to run
        required: false
        default: "jar"

  release:
    types: [created]

# ---------------------------------------------------------------------
# Concurrency ensures that only one execution runs per release tag
# ---------------------------------------------------------------------
concurrency:
  group: ${{ github.workflow }}-${{ github.event.release.tag_name || github.run_id }}
  cancel-in-progress: false

# =====================================================================
# JOB: Build JAR
# =====================================================================
jobs:
  build_jar:
    name: Build JAR
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/build-jar.yml@main
    with:
      release_tag: ${{ github.event.release.tag_name }}
      gradle_task: ${{ inputs.gradle_task || 'jar' }}
      java_version: ${{ inputs.java_version || '17' }}
      java_distribution: ${{ inputs.java_distribution || 'temurin' }}

  # ===================================================================
  # JOB: Detect .iss installer script
  # ===================================================================
  detect_iss:
    name: Detect Setup Script
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/detect-setup-script.yml@main
    with:
      pattern: "**/*.iss"
      fail_if_missing: true

  # ===================================================================
  # JOB: Validate Inputs
  # Ensures build_jar produced a non-empty cache key
  # ===================================================================
  validate_inputs:
    name: Validate JAR Cache Key
    needs: build_jar
    runs-on: ubuntu-latest
    steps:
      - name: Validate jar_cache_key
        run: |
          if [ -z "${{ needs.build_jar.outputs.jar_cache_key }}" ]; then
            echo "::error::JAR cache key is empty!"
            exit 1
          fi

  # ===================================================================
  # JOB: Build Windows Installer using Inno Setup
  # ===================================================================
  build_installer:
    name: Build Windows Installer
    needs: [build_jar, detect_iss, validate_inputs]
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/build-installer.yml@main
    with:
      setup_script: ${{ needs.detect_iss.outputs.setup_script }}
      jar_path: ${{ needs.build_jar.outputs.jar_path }}
      jar_cache_key: ${{ needs.build_jar.outputs.jar_cache_key }}
      app_name: ${{ github.event.repository.name }}
      app_version: ${{ github.event.release.tag_name }}
      output_name: "Setup-${{ github.event.release.tag_name }}"

  # ===================================================================
  # JOB: Upload installer to GitHub Release
  # ===================================================================
  upload_release:
    name: Upload Release Asset
    needs: build_installer
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/upload-release.yml@main
    with:
      tag_name: ${{ github.event.release.tag_name }}
      artifact_name: ${{ needs.build_installer.outputs.installer_artifact_name }}

  # ===================================================================
  # JOB: Notify Success (Microsoft Teams)
  # Only runs on actual release events
  # ===================================================================
  notify_success:
    name: Notify Success
    if: success() && github.event_name == 'release'
    needs: [build_jar, detect_iss, validate_inputs, build_installer, upload_release]
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/teams-notifier.yml@main
    with:
      notification_title: "✅ Build & Release Succeeded!"
      action_required_message: "Release ${{ github.event.release.tag_name }} is ready. View: ${{ github.event.release.html_url }}"
    secrets:
      teams_webhook_url: ${{ secrets.TEAMS_WEBHOOK_URL }}

  # ===================================================================
  # JOB: Notify Failure
  # ===================================================================
  notify_failure:
    name: Notify Failure
    if: failure()
    needs: [build_jar, detect_iss, validate_inputs, build_installer, upload_release]
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/teams-notifier.yml@main
    with:
      notification_title: "🚨 Build & Release Failed!"
      action_required_message: "Check logs: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}"
    secrets:
      teams_webhook_url: ${{ secrets.TEAMS_WEBHOOK_URL }}
