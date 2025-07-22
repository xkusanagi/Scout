#!/bin/bash

# Scout AI Staging Deployment Script
# Usage: ./scripts/deploy-staging.sh

set -e

echo "🧪 Scout AI Staging Deployment"
echo "=============================="

# Check if we're on the dev branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "dev" ]; then
    echo "❌ Error: Must be on dev branch for staging deployment"
    echo "Current branch: $CURRENT_BRANCH"
    exit 1
fi

# Pull latest changes
echo "📥 Pulling latest dev changes..."
git pull origin dev

# Get the latest commit info
COMMIT_HASH=$(git rev-parse --short HEAD)
COMMIT_MESSAGE=$(git log -1 --pretty=%B)

echo "🔄 Deploying commit: $COMMIT_HASH"
echo "📝 Message: $COMMIT_MESSAGE"

echo "📦 Pulling latest Docker images..."
docker-compose -f docker-compose.staging.yaml pull

echo "🔄 Restarting staging services..."
docker-compose -f docker-compose.staging.yaml up -d

echo "⏳ Waiting for services to start..."
sleep 15

# Health check
echo "🩺 Performing health check..."
if curl -s -f http://localhost:8081/health > /dev/null; then
    echo "✅ Staging deployment successful!"
    echo "🧪 Staging at: http://localhost:8081 (or staging.x2501.com if configured)"
else
    echo "❌ Health check failed!"
    echo "📋 Check logs: docker-compose -f docker-compose.staging.yaml logs -f"
    exit 1
fi

echo ""
echo "📊 Deployment Summary:"
echo "  • Commit: $COMMIT_HASH"
echo "  • Branch: dev"
echo "  • URL: http://localhost:8081"
echo "  • Status: ✅ Live"
echo ""
echo "📋 Useful commands:"
echo "  • View logs: docker-compose -f docker-compose.staging.yaml logs -f"
echo "  • Restart: docker-compose -f docker-compose.staging.yaml restart"
echo "  • Stop: docker-compose -f docker-compose.staging.yaml down"