graph TD
  A[📋 Upload Release Asset]
  upload[💼 upload]:::green
  upload-s0[🧩 Download installer a...]
  upload --> upload-s0
  upload-s1[⚙️ Validate artifact di...]
  upload --> upload-s1
  upload-s2[⚙️ List downloaded file...]
  upload --> upload-s2
  upload-s3[⚙️ Validate file presen...]
  upload --> upload-s3
  upload-s4[🧩 Upload to GitHub Rel...]
  upload --> upload-s4

    classDef blue fill:#4A90E2
    classDef green fill:#7ED321
  