#!/bin/bash
# AlphaLearn IDE Installation Script

set -e

echo "🚀 Welcome to AlphaLearn IDE Setup!"
echo "This script will download and configure your local development environment."

# Check if docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker could not be found. Please install Docker Desktop and enable WSL2 integration."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "⚠️ docker-compose not found. Installing..."
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Create directory
mkdir -p ~/alpha-ide
cd ~/alpha-ide

# Download docker-compose.yml
echo "📦 Downloading IDE configuration..."
curl -fsSL "https://raw.githubusercontent.com/relamegt/ide-installlation-steps/refs/heads/main/docker-compose.yml" -o docker-compose.yml

# Create placeholder files to prevent Docker from creating directories for them
touch .gitconfig .git-credentials
mkdir -p .workspace

echo ""
echo "✅ Installation complete!"
echo "To start your IDE (ONE TIME ONLY):"
echo "  cd ~/alpha-ide && docker-compose up -d"
echo ""
echo "After starting, your IDE will permanently run at http://localhost"
