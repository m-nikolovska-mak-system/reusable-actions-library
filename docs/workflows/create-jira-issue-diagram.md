graph TD
  A[📋 Create Jira Issue]
  create-jira[💼 create-jira]:::green
  create-jira-s0[⚙️ Validate inputs and ...]
  create-jira --> create-jira-s0
  create-jira-s1[⚙️ Verify project exist...]
  create-jira --> create-jira-s1
  create-jira-s2[⚙️ Verify issue type is...]
  create-jira --> create-jira-s2
  create-jira-s3[⚙️ Create Jira issue...]
  create-jira --> create-jira-s3
  create-jira-s4[⚙️ Build summary...]
  create-jira --> create-jira-s4

    classDef blue fill:#4A90E2
    classDef green fill:#7ED321
  