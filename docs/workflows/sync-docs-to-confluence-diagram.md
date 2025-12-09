graph TD
  A[📋 Sync Docs to Confluence (Reusable)]
  sync-docs[💼 sync-docs]:::green
  sync-docs-s0[🧩 Checkout...]
  sync-docs --> sync-docs-s0
  sync-docs-s1[🧩 Detect changed files...]
  sync-docs --> sync-docs-s1
  sync-docs-s2[⚙️ Check if docs change...]
  sync-docs --> sync-docs-s2
  sync-docs-s3[⚙️ List changed docs...]
  sync-docs --> sync-docs-s3
  sync-docs-s4[⚙️ Warn on renamed/move...]
  sync-docs --> sync-docs-s4

    classDef blue fill:#4A90E2
    classDef green fill:#7ED321
  