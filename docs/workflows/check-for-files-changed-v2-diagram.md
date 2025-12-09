graph TD
  A[📋 Check File Changes]
  check-changes[💼 check-changes]:::green
  check-changes-s0[🧩 Checkout calling rep...]
  check-changes --> check-changes-s0
  check-changes-s1[🧩 Checkout reusable wo...]
  check-changes --> check-changes-s1
  check-changes-s2[⚙️ Make helper scripts ...]
  check-changes --> check-changes-s2
  check-changes-s3[⚙️ Run tag detection...]
  check-changes --> check-changes-s3
  check-changes-s4[⚙️ Check for file chang...]
  check-changes --> check-changes-s4

    classDef blue fill:#4A90E2
    classDef green fill:#7ED321
  