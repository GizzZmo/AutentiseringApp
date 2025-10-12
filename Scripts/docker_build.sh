#!/bin/bash
echo "🐳 Bygger Docker-container..."
docker build -t autentisering-app .

echo "🚀 Starter container..."
docker run -p 8080:8080 autentisering-app
