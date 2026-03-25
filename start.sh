#!/bin/sh
set -e

echo "Starting nginx..."
nginx -t  # Test configuration
nginx

echo "Nginx started successfully"

# Wait a moment for nginx to fully start
sleep 2

echo "Checking nginx status..."
if ! pgrep -x "nginx" > /dev/null; then
    echo "ERROR: Nginx failed to start"
    exit 1
fi

echo "Starting backend..."
cd /app/backend
exec node app.js