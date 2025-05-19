#!/bin/bash

set -e  # Stop script on error
LOG_FILE="deploy.log"

# Sjekk at nødvendige miljøvariabler er satt
if [[ -z "$DB_HOST" || -z "$DB_USER" || -z "$DB_PASSWORD" || -z "$API_KEY" ]]; then
    echo "Feil: Mangler en eller flere nødvendige miljøvariabler!" | tee -a $LOG_FILE
    exit 1
fi

echo "Starter deployment..." | tee -a $LOG_FILE

# Deploy-applikasjonen
if ! docker-compose up -d --build 2>&1 | tee -a $LOG_FILE; then
    echo "Feil under deployment! Starter rollback..." | tee -a $LOG_FILE
    docker-compose down | tee -a $LOG_FILE
    exit 1
fi

echo "Deployment fullført!" | tee -a $LOG_FILE

# Git-kommandoer
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
