# 🔨 Build JAR Reusable Workflow

**File:** `.github/workflows/build-jar.yml`  
**Type:** Reusable Workflow (Called by other workflows)  
**Purpose:** Compiles your Java code into a `.jar` file using Gradle  

---

## 🎯 What This Does (Plain English)

This workflow takes your Java source code, runs Gradle to compile it, produces a JAR file, and saves it so other workflows can use it.

**What you give it:**
- Java version (17, 21, etc.)
- Gradle task (jar, shadowJar, etc.)

**What you get back:**
- ✅ Compiled `.jar` file
- ✅ Cache key to retrieve it later
- ✅ File name and path

---

## 📥 Inputs (What You Customize)

All inputs are **optional** because they have defaults. Override them if you need something different.

| Input | Type | Default | What It Does | Example |
|-------|------|---------|-------------|---------|
| `java_version` | string | `17` | Which Java version to use for compilation | `17`, `21`, or `11` |
| `java_distribution` | string | `temurin` | Which Java provider to use | `temurin`, `zulu`, `corretto` |
| `gradle_task` | string | `jar` | Which Gradle task to run | `jar`, `shadowJar`, `build` |
| `release_tag` | string | `main` | Which Git branch/tag to build | `main`, `v1.0.0`, `develop` |
| `jar_output_path` | string | `build/libs/*.jar` | Where Gradle outputs the JAR | `build/libs/*.jar` |
| `additional_gradle_args` | string | `--no-daemon` | Extra Gradle flags | `--info`, `--stacktrace` |

---

## 📤 Outputs (What You Get Back)

These are values the workflow creates that other jobs can use.

| Output | What It Contains | Example |
|--------|-----------------|---------|
| `jar_cache_key` | A unique key to retrieve the JAR later | `jar-abc123def456` |
| `jar_filename` | Just the filename of the JAR | `myapp-1.0.0.jar` |
| `jar_path` | Full path to where JAR is stored | `build/libs/myapp-1.0.0.jar` |

---

## 💡 Usage Examples

### Example 1: Simple Build (Using All Defaults)

```yaml
jobs:
  build:
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/build-jar.yml@main
    with:
      release_tag: main
```

**What happens:**
- ✅ Java 17 is installed
- ✅ `./gradlew jar` is run
- ✅ JAR is created and cached

---

### Example 2: Build with Java 21 & Fat JAR

```yaml
jobs:
  build:
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/build-jar.yml@main
    with:
      java_version: "21"
      gradle_task: "shadowJar"
      release_tag: v1.0.0
```

**What happens:**
- ✅ Java 21 is installed
- ✅ `./gradlew shadowJar` creates a fat JAR (all dependencies included)
- ✅ JAR from tag `v1.0.0` is built

---

### Example 3: Build with Debug Info

```yaml
jobs:
  build:
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/build-jar.yml@main
    with:
      gradle_task: build
      additional_gradle_args: "--info --stacktrace"
```

**What happens:**
- ✅ Runs `./gradlew build --info --stacktrace` (verbose output for debugging)

---

### Example 4: Using Outputs in Next Job

```yaml
jobs:
  build_jar:
    uses: m-nikolovska-mak-system/reusable-actions-library/.github/workflows/build-jar.yml@main
    with:
      release_tag: main

  next_job:
    needs: build_jar
    runs-on: ubuntu-latest
    steps:
      - name: Use JAR info
        run: |
          echo "JAR Filename: ${{ needs.build_jar.outputs.jar_filename }}"
          echo "Cache Key: ${{ needs.build_jar.outputs.jar_cache_key }}"
          echo "JAR Path: ${{ needs.build_jar.outputs.jar_path }}"
```

---

## 🔍 What Happens Inside (Step-by-Step)

1. **Checkout code** from the Git ref you specified
2. **Install Java** (version + distribution you chose)
3. **Make Gradle executable** (chmod +x)
4. **Setup Gradle cache** (speeds up subsequent builds)
5. **Run Gradle task** (compiles your code)
6. **Validate JAR exists** (checks it was actually built)
7. **Generate cache key** (unique ID to retrieve JAR later)
8. **Cache the JAR** (saves it for other jobs)
9. **Summary report** (shows what was built)

---

## ❌ Troubleshooting

### Problem: "No JAR file found at build/libs/*.jar"

**Why it happens:**
- Build failed
- Gradle task doesn't output a JAR
- `build.gradle` has an error

**How to fix:**
1. Check the build logs for error messages
2. Verify `build.gradle` or `build.gradle.kts` exists
3. Try running `./gradlew jar` locally first
4. Check that output path matches your build script

**Debug tip:** Add `--info --stacktrace` to `additional_gradle_args`

---

### Problem: "Gradle wrapper not executable"

**Why it happens:**
- `.gradle/wrapper/gradle-wrapper.jar` not committed to repo
- File permissions issue

**How to fix:**
1. Make sure `.gradle/` folder is in your repo
2. Run locally: `chmod +x gradlew`
3. Commit and push: `git add gradlew && git commit -m "Add gradle wrapper"`

---

### Problem: Build is super slow (first time)

**Why it happens:**
- First build always downloads dependencies (normal!)
- Gradle cache is empty

**How to fix:**
- Just wait. First build takes 5-10 minutes
- Subsequent builds use cache = faster

---

### Problem: Wrong Java version detected

**Why it happens:**
- `java_version` and `java_distribution` mismatch
- Runner has stale Java cached

**How to fix:**
1. Double-check `java_version` (must be valid: 11, 17, 21)
2. Try `java_distribution: temurin` (most reliable)
3. Check action logs: does it say "Setting up Java X.Y.Z"?

---

## 🎛️ Common Gradle Tasks

| Task | What It Does | When To Use |
|------|-------------|------------|
| `jar` | Basic JAR (default) | Most projects |
| `shadowJar` | Fat JAR (all dependencies inside) | Need everything in one file |
| `bootJar` | Spring Boot JAR | Spring Boot apps |
| `build` | Full build + tests | Full quality check |
| `clean build` | Delete old build + build fresh | When something seems cached wrong |

---

## 📊 Real Example

Your main workflow calls this:

```yaml
jobs:
  build_jar:
    uses: reusable-actions-library/.github/workflows/build-jar.yml@main
    with:
      java_version: "17"
      gradle_task: "jar"
      release_tag: main

  build_installer:
    needs: build_jar
    uses: reusable-actions-library/.github/workflows/build-installer.yml@main
    with:
      jar_cache_key: ${{ needs.build_jar.outputs.jar_cache_key }}
      jar_path: ${{ needs.build_jar.outputs.jar_path }}
```

**What happens:**
1. ✅ Job 1 builds the JAR and outputs cache key
2. ✅ Job 2 waits for Job 1 to finish
3. ✅ Job 2 gets the cache key from Job 1's outputs
4. ✅ Job 2 uses that to retrieve and work with the JAR

---

## 📝 Checklist Before Using

- [ ] `build.gradle` or `build.gradle.kts` exists in repo root
- [ ] `.gradle/` wrapper folder committed to repo
- [ ] `./gradlew` is executable locally (`ls -la gradlew`)
- [ ] `gradle jar` works locally without errors
- [ ] Java version is compatible (11, 17, 21)
- [ ] No weird characters or spaces in file paths

---

## 🤔 FAQ

**Q: Can I use Maven instead of Gradle?**  
A: This workflow is Gradle-only. Contact Platform Eng for Maven support.

**Q: What if my JAR is named differently?**  
A: Override `jar_output_path` to match your build script output.

**Q: Can I run tests?**  
A: Yes, use `gradle_task: build` (includes tests).

**Q: How long does this take?**  
A: First build: 5-10 min. Subsequent: 2-3 min (cached).

**Q: What if I have multiple JARs?**  
A: Workflow picks the first one found. Contact Platform Eng if you need multiple.

---

## 🔗 Related Docs

- [Gradle Documentation](https://docs.gradle.org)
- [GitHub Actions Setup Java](https://github.com/actions/setup-java)
- [GitHub Actions Cache](https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows)
- [Main Build & Release Workflow](../build-and-release-v3.md)

---

**Questions?** Slack #platform-engineering or open an issue in the reusable-actions-library repo
