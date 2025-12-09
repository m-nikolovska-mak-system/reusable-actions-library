graph TD
  A[📋 Notify on Release Changes]
  detect-and-notify[💼 detect-and-notify]:::green
  detect-and-notify-s0[🧩 Checkout code...]
  detect-and-notify --> detect-and-notify-s0
  detect-and-notify-s1[🧩 Detect file changes...]
  detect-and-notify --> detect-and-notify-s1
  detect-and-notify-s2[⚙️ Prepare notification...]
  detect-and-notify --> detect-and-notify-s2
  detect-and-notify-s3[🧩 Send Teams notificat...]
  detect-and-notify --> detect-and-notify-s3

    classDef blue fill:#4A90E2
    classDef green fill:#7ED321
  