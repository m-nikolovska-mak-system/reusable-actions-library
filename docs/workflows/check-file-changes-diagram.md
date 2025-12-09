```mermaid
graph TD
  A[📋 Check File Changes (Universal)]
  detect[💼 detect]:::green
  detect-s0[🧩 action...]
  detect --> detect-s0
  detect-s1[⚙️ Auto-detect refs...]
  detect --> detect-s1
  detect-s2[🧩 Detect changed files...]
  detect --> detect-s2
  detect-s3[⚙️ Debug output...]
  detect --> detect-s3

    classDef blue fill:#4A90E2
    classDef green fill:#7ED321
  
