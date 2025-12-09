graph TD
  A[📋 Release File Watcher]
  check-changes[💼 check-changes]:::green
  check-changes-s0[🧩 Checkout repository...]
  check-changes --> check-changes-s0
  check-changes-s1[⚙️ Get previous release...]
  check-changes --> check-changes-s1
  check-changes-s2[⚙️ Check for file chang...]
  check-changes --> check-changes-s2
  notify[💼 notify]:::blue
  notify-s0[⚙️ Send Teams notificat...]
  notify --> notify-s0

    classDef blue fill:#4A90E2
    classDef green fill:#7ED321
  