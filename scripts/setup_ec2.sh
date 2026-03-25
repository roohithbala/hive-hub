#!/bin/bash
# Setup Docker and Docker Compose on Ubuntu

set -e

if ! command -v curl >/dev/null 2>&1; then
	echo "Installing curl..."
	sudo apt-get update
	sudo apt-get install -y curl
fi

if ! command -v docker >/dev/null 2>&1; then
	echo "Installing Docker..."
	sudo apt-get update
	sudo apt-get install -y docker.io docker-compose-v2
else
	echo "Docker already installed. Skipping."
	if ! docker compose version >/dev/null 2>&1; then
		echo "Installing Docker Compose v2..."
		sudo apt-get update
		sudo apt-get install -y docker-compose-v2
	fi
fi

echo "Enabling Docker service..."
sudo systemctl enable --now docker

if ! id -nG "$USER" | grep -qw docker; then
	echo "Adding current user to docker group..."
	sudo usermod -aG docker $USER
else
	echo "User already in docker group. Skipping."
fi

echo "Checking for k3s..."
if command -v k3s >/dev/null 2>&1; then
	echo "k3s already installed. Skipping."
else
	echo "Installing k3s..."
	curl -sfL https://get.k3s.io | sudo sh -
	sudo systemctl enable --now k3s
fi

echo "✅ Setup complete! Please log out and log back in for group changes to take effect."
echo "Or run: newgrp docker"
