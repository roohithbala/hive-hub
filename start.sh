#!/bin/sh
set -e

# echo "Check configuration"
nginx -t

echo "Verifying frontend build..."
if [ ! -f "/usr/share/nginx/html/index.html" ]; then
    echo "ERROR: index.html not found in /usr/share/nginx/html/"
    ls -la /usr/share/nginx/html/
    exit 1
fi

echo "Creating debug test.html..."
echo "<html><body><h1>Nginx is working</h1></body></html>" > /usr/share/nginx/html/test.html
chmod 644 /usr/share/nginx/html/test.html

echo "Starting backend in background..."
cd /app/backend
node app.js &

# Wait for backend to start
sleep 5

echo "Starting nginx in foreground..."
nginx