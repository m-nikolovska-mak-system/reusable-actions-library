graph TD
  A[📋 Check File Changes Between Releases]
  check-changes[💼 check-changes]:::green
  check-changes-s0[🧩 Checkout repository...]
  check-changes --> check-changes-s0
  check-changes-s1[⚙️ Determine tags to co...]
  check-changes --> check-changes-s1
  check-changes-s2[🧩 Get all changed file...]
  check-changes --> check-changes-s2
  check-changes-s3[🧩 Check watched files...]
  check-changes --> check-changes-s3
  check-changes-s4[⚙️ Display results...]
  check-changes --> check-changes-s4

    classDef blue fill:#4A90E2
    classDef green fill:#7ED321
  