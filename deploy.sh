#!/usr/bin/env bash
set -euo pipefail

# Simple deploy script for Option A (build on VM)
# Usage: edit REPO_URL then run: ./deploy.sh

REPO_URL="https://github.com/<your-org>/AddiPi.git"  # <- replace
WORKDIR="$HOME/AddiPi"

echo "Deploy: repo -> $WORKDIR"

if [ ! -d "$WORKDIR" ]; then
  echo "Cloning repo..."
  git clone "$REPO_URL" "$WORKDIR"
else
  echo "Repo exists, fetching latest..."
  cd "$WORKDIR"
  git fetch --all --prune
  git reset --hard origin/main
fi

cd "$WORKDIR/AddiPi-Infrastructure"

if [ ! -f .env ]; then
  echo "ERROR: .env not found in AddiPi-Infrastructure. Create it with required env vars and rerun."
  exit 1
fi

echo "Building and starting services with docker compose..."
docker compose -f docker-compose.yml pull || true
docker compose -f docker-compose.yml up -d --build

echo "Deployment complete. Check services with: docker compose ps" 
echo "View logs: docker compose logs -f files" 
