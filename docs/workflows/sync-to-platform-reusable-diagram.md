graph TD
  A[📋 Sync Files to Platform (Reusable)]
  sync-files[💼 sync-files]:::green
  sync-files-s0[🧩 Checkout Source Repo...]
  sync-files --> sync-files-s0
  sync-files-s1[🧩 Checkout Destination...]
  sync-files --> sync-files-s1
  sync-files-s2[⚙️ Detect Files to Sync...]
  sync-files --> sync-files-s2
  sync-files-s3[⚙️ Copy Files to Destin...]
  sync-files --> sync-files-s3
  sync-files-s4[⚙️ Commit Changes to De...]
  sync-files --> sync-files-s4

    classDef blue fill:#4A90E2
    classDef green fill:#7ED321
  