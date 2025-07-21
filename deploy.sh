#!/bin/bash

# Scout AI Deployment Script for DigitalOcean
# This script helps deploy Open WebUI to a DigitalOcean droplet

set -e

echo "🚀 Scout AI Deployment Script"
echo "=============================="

# Check if running on DigitalOcean droplet
if [ ! -f /etc/digitalocean ]; then
    echo "⚠️  Warning: This doesn't appear to be a DigitalOcean droplet"
    read -p "Continue anyway? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Update system
echo "📦 Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install Docker if not present
if ! command -v docker &> /dev/null; then
    echo "🐳 Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
fi

# Install Docker Compose if not present
if ! command -v docker-compose &> /dev/null; then
    echo "🔧 Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Pull latest images
echo "📥 Pulling latest Docker images..."
docker-compose -f docker-compose.production.yaml pull

# Start services
echo "🚀 Starting Scout AI services..."
docker-compose -f docker-compose.production.yaml up -d

# Wait for services to start
echo "⏳ Waiting for services to start..."
sleep 30

# Check if services are running
if docker-compose -f docker-compose.production.yaml ps | grep -q "Up"; then
    echo "✅ Scout AI is now running!"
    echo ""
    echo "🌐 Access your Scout AI instance at:"
    echo "   http://$(curl -s ifconfig.me)"
    echo ""
    echo "📋 Next steps:"
    echo "   1. Create your admin account"
    echo "   2. Set ENABLE_SIGNUP=False in docker-compose.production.yaml"
    echo "   3. Restart with: docker-compose -f docker-compose.production.yaml restart"
    echo ""
    echo "📊 View logs: docker-compose -f docker-compose.production.yaml logs -f"
    echo "🛑 Stop services: docker-compose -f docker-compose.production.yaml down"
else
    echo "❌ Something went wrong. Check logs:"
    docker-compose -f docker-compose.production.yaml logs
fi