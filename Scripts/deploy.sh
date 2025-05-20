#!/bin/bash

set -e  # Stop script on error
LOG_FILE="deploy.log"

# Sjekk at nødvendige miljøvariabler er satt
if [[ -z "$DB_HOST" || -z "$DB_USER" || -z "$DB_PASSWORD" || -z "$API_KEY" ]]; then
    echo "Feil: Mangler en eller flere nødvendige miljøvariabler!" | tee -a $LOG_FILE
    exit 1
fi

# Sjekk at Docker er installert
if ! command -v docker &>/dev/null; then
    echo "Feil: Docker er ikke installert!" | tee -a $LOG_FILE
    exit 1
fi

# Sjekk at git remote 'origin' er satt
if ! git remote | grep -q origin; then
    echo "Feil: git remote 'origin' er ikke satt." | tee -a $LOG_FILE
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

# Ekstra sjekk og feilhåndtering for eksternt script
if [[ -x Scripts/slack_notify.sh ]]; then
    sh Scripts/slack_notify.sh
else
    echo "Advarsel: Scripts/slack_notify.sh finnes ikke eller er ikke kjørbar, Slack-varsling hoppet over." | tee -a $LOG_FILE
fi
