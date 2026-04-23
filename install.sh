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

# CLEANUP: Remove any "fake" directories or old configs created by previous failed attempts
# This ensures the IDE starts fresh with no password requirement.
rm -rf start.sh docker-entrypoint.sh .gitconfig .git-credentials config .config

# Fix Docker credential error on WSL (docker-credential-desktop.exe issue)
# This prevents 'exec format error' when pulling images on Linux/WSL
mkdir -p ~/.docker
echo '{}' > ~/.docker/config.json

# Create workspace directory
mkdir -p .workspace

# Generate the docker-compose.yml directly (clean student version — no dev-only mounts)
echo "📝 Creating IDE configuration..."
cat > docker-compose.yml << 'EOF'
services:
  alpha-ide:
    ipc: host
    restart: always
    image: realmegtnoet/alphalearnide:latest
    container_name: alpha-ide
    ports:
      - "80:8080"
      - "3000:3000"
      - "3001:3001"
      - "3002:3002"
      - "3003:3003"
      - "5000:5000"
      - "5500:5500"
      - "8000:8000"
      - "8080:8080"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=UTC
      - AUTH=none
      - SUDO_PASSWORD=password
      - API_BASE_URL=http://host.docker.internal:4000
      - ALPHA_BACKEND=http://host.docker.internal:4000
    extra_hosts:
      - "host.docker.internal:host-gateway"
    entrypoint: ["/bin/bash", "/docker-entrypoint.sh"]
    volumes:
      - "./.workspace/:/home/workspace/"
      - "alpha-auth:/home/alpha-config/"

volumes:
  alpha-auth:
EOF


echo ""
echo "✅ Installation complete!"
echo "To start your IDE (ONE TIME ONLY):"
echo "  cd ~/alpha-ide && docker-compose up -d"
echo ""
echo "After starting, your IDE will permanently run at http://localhost"
