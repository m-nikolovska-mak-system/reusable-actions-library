# 🔍 Detect Setup Script Reusable Workflow

**File:** [`.github/workflows/detect-setup-script.yml`](https://github.com/m-nikolovska-mak-system/reusable-actions-library/blob/main/.github/workflows/detect-setup-script.yml) 
**Type:** Reusable Workflow (Called by other workflows)  
**Purpose:** Searches your repository for Inno Setup (`.iss`) installer scripts and returns their paths for downstream jobs.

---

## 🎯 What This Does

This workflow scans your codebase for files matching a glob pattern (default: `**/*.iss`). It:
- ✅ Finds all matching setup scripts
- ✅ Returns the first match for convenience
- ✅ Optionally fails if no scripts are found (configurable)

**What you give it:**
- A glob pattern for `.iss` files
- Whether to fail if no match is found

**What you get back:**
- ✅ Path to the first matching setup script
- ✅ Comma-separated list of all matches

---

## 📥 Inputs (What You Customize)

| Input | Type | Default | What It Does | Example |
|-------|------|---------|-------------|---------|
| `pattern` | string | `**/*.iss` | Glob pattern to search for setup scripts | `installer/*.iss` |
| `fail_if_missing` | boolean | `true` | Fail workflow if no scripts found | `false` |

---

## 📤 Outputs (What You Get Back)

| Output | What It Contains | Example |
|--------|-----------------|---------|
| `setup_script` | Path to the first matching script | `installer/setup.iss` |
| `all_scripts` | Comma-separated list of all matches | `installer/setup.iss,installer/alt.iss` |

---

## 💡 Usage Examples

### Example 1: Use Defaults (Search for any `.iss` file)
```yaml
jobs:
  detect_iss:
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/detect-setup-script.yml@main
