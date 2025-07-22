#!/bin/bash

# Scout AI - User Activity Monitor
# Usage: ./scripts/monitor-user-activity.sh demo@x2501.com

USER_EMAIL="${1:-demo@x2501.com}"

echo "📊 Scout AI User Activity Monitor"
echo "================================="
echo "User: $USER_EMAIL"
echo "Date: $(date)"
echo ""

# Get container logs for this user
echo "🔍 Recent Activity (Last 100 lines):"
docker-compose -f docker-compose.production.yaml logs --tail=100 open-webui | grep -i "$USER_EMAIL" | tail -20

echo ""
echo "📈 Usage Statistics:"

# Database queries (if accessible)
if command -v sqlite3 &> /dev/null; then
    echo "Querying database..."
    docker exec -it open-webui sqlite3 /app/backend/data/webui.db << EOF
.headers on
.mode table

-- User info
SELECT 'User Info:' as metric, email, name, role, created_at, updated_at 
FROM user WHERE email = '$USER_EMAIL';

-- Chat count
SELECT 'Total Chats:' as metric, COUNT(*) as count 
FROM chat WHERE user_id = (SELECT id FROM user WHERE email = '$USER_EMAIL');

-- Recent chats
SELECT 'Recent Chats:' as metric, title, created_at 
FROM chat WHERE user_id = (SELECT id FROM user WHERE email = '$USER_EMAIL') 
ORDER BY created_at DESC LIMIT 5;
EOF
else
    echo "SQLite not available - using log analysis only"
fi

echo ""
echo "🕒 Session Activity (Last 24h):"
docker-compose -f docker-compose.production.yaml logs --since=24h open-webui | grep -i "$USER_EMAIL" | wc -l | xargs echo "Log entries:"

echo ""
echo "📋 To get detailed analytics:"
echo "  • docker-compose -f docker-compose.production.yaml logs open-webui | grep '$USER_EMAIL'"
echo "  • Admin Panel → Users → $USER_EMAIL"