graph TD
  A[📋 Auto-Generate Workflow Documentation (Reusable)]
  detect-changes[💼 detect-changes]:::green
  detect-changes-s0[🧩 action...]
  detect-changes --> detect-changes-s0
  detect-changes-s1[🧩 Detect changed workf...]
  detect-changes --> detect-changes-s1
  detect-changes-s2[⚙️ Prepare matrix JSON...]
  detect-changes --> detect-changes-s2
  detect-changes-s3[⚙️ Get PR source branch...]
  detect-changes --> detect-changes-s3
  update-doc[💼 update-doc]:::blue
  update-doc-s0[🧩 action...]
  update-doc --> update-doc-s0
  update-doc-s1[🧩 action...]
  update-doc --> update-doc-s1
  update-doc-s2[⚙️ pip install pyyaml...]
  update-doc --> update-doc-s2
  update-doc-s3[⚙️ mkdir -p docs...]
  update-doc --> update-doc-s3
  update-doc-s4[⚙️ Create missing READM...]
  update-doc --> update-doc-s4

    classDef blue fill:#4A90E2
    classDef green fill:#7ED321
  