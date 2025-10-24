#!/bin/bash
set -e

WEBHOOK_URL="$1"
TITLE="$2"
MESSAGE="$3"
COLOR="$4"
SHOW_FILES="$5"
CHANGED_FILES="$6"
LINK_URL="$7"

TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%S UTC")

# Build file list JSON safely
FILES_JSON=""
if [ "$SHOW_FILES" == "true" ] && [ -n "$CHANGED_FILES" ]; then
  while IFS= read -r file; do
    FILES_JSON="${FILES_JSON}{\"type\": \"TextBlock\", \"text\": \"• ${file}\", \"wrap\": true},"
  done <<< "$CHANGED_FILES"
  FILES_JSON="${FILES_JSON%,}"  # remove trailing comma
fi

# Build the Adaptive Card payload safely
read -r -d '' PAYLOAD <<EOF
{
  "type": "message",
  "attachments": [
    {
      "contentType": "application/vnd.microsoft.card.adaptive",
      "content": {
        "\$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
        "type": "AdaptiveCard",
        "version": "1.4",
        "body": [
          {
            "type": "TextBlock",
            "text": "${TITLE:-GitHub Notification}",
            "weight": "Bolder",
            "size": "Large",
            "color": "Accent",
            "wrap": true
          },
          {
            "type": "TextBlock",
            "text": "${MESSAGE}",
            "wrap": true
          },
          {
            "type": "TextBlock",
            "text": "🕒 Timestamp: ${TIMESTAMP}",
            "wrap": true
          }
          $( [ -n "$FILES_JSON" ] && echo ", { \"type\": \"Container\", \"items\": [ $FILES_JSON ] }" )
        ],
        "actions": [
          {
            "type": "Action.OpenUrl",
            "title": "View Details",
            "url": "${LINK_URL:-https://github.com}"
          }
        ]
      }
    }
  ]
}
EOF

curl -s -H "Content-Type: application/json" -d "$PAYLOAD" "$WEBHOOK_URL"
