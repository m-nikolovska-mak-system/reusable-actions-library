graph TD
  A[📋 Generate Workflow Documentation]
  generate-docs[💼 generate-docs]:::green
  generate-docs-s0[🧩 Checkout...]
  generate-docs --> generate-docs-s0
  generate-docs-s1[🧩 Setup Node...]
  generate-docs --> generate-docs-s1
  generate-docs-s2[⚙️ Create script direct...]
  generate-docs --> generate-docs-s2
  generate-docs-s3[⚙️ Download doc generat...]
  generate-docs --> generate-docs-s3
  generate-docs-s4[⚙️ Install dependencies...]
  generate-docs --> generate-docs-s4

    classDef blue fill:#4A90E2
    classDef green fill:#7ED321
  