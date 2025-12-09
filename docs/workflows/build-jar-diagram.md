graph TD
  A[📋 Build JAR with Gradle]
  build[💼 build]:::green
  build-s0[🧩 Checkout repository...]
  build --> build-s0
  build-s1[🧩 Set up Java ${{ inpu...]
  build --> build-s1
  build-s2[⚙️ Make Gradle wrapper ...]
  build --> build-s2
  build-s3[🧩 Setup Gradle cache...]
  build --> build-s3
  build-s4[⚙️ Build JAR with Gradl...]
  build --> build-s4

    classDef blue fill:#4A90E2
    classDef green fill:#7ED321
  