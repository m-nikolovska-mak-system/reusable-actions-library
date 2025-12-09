graph TD
  A[📋 Assign Jira Issue (Safe Version)]
  assign[💼 assign]:::green
  assign-s0[⚙️ Ensure jq is install...]
  assign --> assign-s0
  assign-s1[⚙️ Validate inputs and ...]
  assign --> assign-s1
  assign-s2[⚙️ Search Jira user by ...]
  assign --> assign-s2
  assign-s3[⚙️ Check if user is ass...]
  assign --> assign-s3
  assign-s4[⚙️ Assign Jira issue...]
  assign --> assign-s4

    classDef blue fill:#4A90E2
    classDef green fill:#7ED321
  