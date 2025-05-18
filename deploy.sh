#!/bin/bash

echo "🚀 Initialiserer Git-repo..."
git init
git add .
git commit -m "Automatisk deploy via script"

echo "🛠 Setter opp branch..."
git branch -M main

echo "📤 Skyver til GitHub..."
git push -u origin main

echo "✅ Deploy ferdig! Sender Slack-varsel..."
sh Scripts/slack_notify.sh
