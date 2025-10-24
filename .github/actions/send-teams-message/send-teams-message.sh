#!/usr/bin/env bash
set -e

WEBHOOK_URL="$1"
TITLE="$2"
MESSAGE="$3"
COLOR="${4:-#0078D7}" # Default Teams blue
SHOW_FILES="$5"
CHANGED_FILES="$6"
LINK_URL="$7"

TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%S UTC")

# Optional file list block
if [[ "$SHOW_FILES" == "true" && -n "$CHANGED_FILES" ]]; then
  FILES_SECTION="{
    \"type\": \"FactSet\",
    \"facts\": [
      { \"title\": \"Changed Files:\", \"value\": \"${CHANGED_FILES//$'\n'/\\n}\" }
    ]
  },"
else
  FILES_SECTION=""
fi

# Optional link button
if [[ -n "$LINK_URL" ]]; then
  LINK_ACTION="{
    \"type\": \"Action.OpenUrl\",
    \"title\": \"View Details\",
    \"url\": \"$LINK_URL\"
  }"
else
  LINK_ACTION=""
fi

# Create Adaptive Card JSON
CARD_PAYLOAD=$(cat <<EOF
{
  "@type": "MessageCard",
  "@context": "https://schema.org/extensions",
  "themeColor": "$COLOR",
  "summary": "$TITLE",
  "sections": [
    {
      "activityTitle": "**$TITLE**",
      "text": "$MESSAGE",
      $FILES_SECTION
      {
        "type": "FactSet",
        "facts": [
          { "title": "Time", "value": "$TIMESTAMP" }
        ]
      }
    }
  ],
  "potentialAction": [
    $LINK_ACTION
  ]
}
EOF
)

# Post to Teams
curl -H "Content-Type: application/json" -d "$CARD_PAYLOAD" "$WEBHOOK_URL"
