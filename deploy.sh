#!/usr/bin/env bash
set -euo pipefail

# Ensure we're in the project root
cd "$(dirname "$0")"

echo "🚀 Starting deployment with Docker Compose..."

# Pull latest images
sudo docker compose pull

# Stop and remove old containers to avoid race conditions
sudo docker compose down --remove-orphans

# Start services
sudo docker compose up -d

echo "✅ Deployment complete. Watchtower is now monitoring for updates."
