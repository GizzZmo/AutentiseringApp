#!/bin/bash

SLACK_WEBHOOK_URL="https://hooks.slack.com/services/YOUR_WEBHOOK_URL"

# Slack-melding
PAYLOAD='{
    "text": "🚀 Ny oppdatering på GitHub! AutentiseringApp er nå live.",
    "username": "GitHubBot",
    "icon_emoji": ":rocket:"
}'

# Send melding
curl -X POST -H 'Content-type: application/json' --data "$PAYLOAD" "$SLACK_WEBHOOK_URL"
