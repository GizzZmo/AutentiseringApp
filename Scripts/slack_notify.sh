#!/bin/bash

set -euo pipefail

# Check if environment variable is set
SLACK_WEBHOOK_URL=${SLACK_WEBHOOK_URL:?Environment variable not set}

# Default message or use the first argument
MESSAGE=${1:-"🚀 Default notification message"}

# Construct the payload
PAYLOAD=$(cat <<EOF
{
    "text": "$MESSAGE",
    "username": "GitHubBot",
    "icon_emoji": ":rocket:"
}
EOF
)

# Send the request and capture the response
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H 'Content-type: application/json' --data "$PAYLOAD" "$SLACK_WEBHOOK_URL")

# Check if the request was successful
if [ "$RESPONSE" -ne 200 ]; then
    echo "Failed to send notification to Slack. HTTP response code: $RESPONSE"
    exit 1
fi

# Optional: Log the result
echo "$(date) - Slack notification sent: $MESSAGE" >> /var/log/slack_notify.log
