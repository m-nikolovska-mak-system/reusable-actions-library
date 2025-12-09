graph TD
  A[📋 Build Windows Installer with Inno Setup]
  build-installer[💼 build-installer]:::green
  build-installer-s0[🧩 Checkout repository...]
  build-installer --> build-installer-s0
  build-installer-s1[🧩 Restore cached JAR...]
  build-installer --> build-installer-s1
  build-installer-s2[⚙️ Verify JAR was resto...]
  build-installer --> build-installer-s2
  build-installer-s3[⚙️ Ensure JAR cache key...]
  build-installer --> build-installer-s3
  build-installer-s4[⚙️ Debug Inputs...]
  build-installer --> build-installer-s4

    classDef blue fill:#4A90E2
    classDef green fill:#7ED321
  