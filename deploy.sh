#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="${IMAGE_NAME:-ghcr.io/sarvesh4329/hive-help}"
IMAGE="${IMAGE:-${IMAGE_NAME}:latest}"
CONTAINER_NAME="${CONTAINER_NAME:-hive-help-backend}"
PORT="${PORT:-5000}"

docker pull "$IMAGE"

if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  docker rm -f "$CONTAINER_NAME"
fi

docker run -d \
  --name "$CONTAINER_NAME" \
  -p "${PORT}:5000" \
  --restart unless-stopped \
  "$IMAGE"
