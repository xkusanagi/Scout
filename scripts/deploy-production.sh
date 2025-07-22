#!/bin/bash

# Scout AI Production Deployment Script
# Usage: ./scripts/deploy-production.sh

set -e

echo "🚀 Scout AI Production Deployment"
echo "=================================="

# Check if we're on the main branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "❌ Error: Must be on main branch for production deployment"
    echo "Current branch: $CURRENT_BRANCH"
    exit 1
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "❌ Error: You have uncommitted changes"
    git status --short
    exit 1
fi

# Pull latest changes
echo "📥 Pulling latest changes..."
git pull origin main

# Get the latest commit info
COMMIT_HASH=$(git rev-parse --short HEAD)
COMMIT_MESSAGE=$(git log -1 --pretty=%B)

echo "🔄 Deploying commit: $COMMIT_HASH"
echo "📝 Message: $COMMIT_MESSAGE"

# Ask for confirmation
read -p "🚨 Deploy to PRODUCTION (demo.x2501.com)? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Deployment cancelled"
    exit 1
fi

echo "📦 Pulling latest Docker images..."
docker-compose -f docker-compose.production.yaml pull

echo "🔄 Restarting services..."
docker-compose -f docker-compose.production.yaml up -d

echo "⏳ Waiting for services to start..."
sleep 15

# Health check
echo "🩺 Performing health check..."
if curl -s -f http://localhost/health > /dev/null; then
    echo "✅ Production deployment successful!"
    echo "🌐 Live at: https://demo.x2501.com"
else
    echo "❌ Health check failed!"
    echo "📋 Check logs: docker-compose -f docker-compose.production.yaml logs -f"
    exit 1
fi

echo ""
echo "📊 Deployment Summary:"
echo "  • Commit: $COMMIT_HASH"
echo "  • URL: https://demo.x2501.com"
echo "  • Status: ✅ Live"
echo ""
echo "📋 Useful commands:"
echo "  • View logs: docker-compose -f docker-compose.production.yaml logs -f"
echo "  • Restart: docker-compose -f docker-compose.production.yaml restart"
echo "  • Stop: docker-compose -f docker-compose.production.yaml down"