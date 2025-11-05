#!/bin/bash
# EC2 Deployment Script
# This script is used by GitHub Actions for automated deployment
# Can also be run manually on EC2 instance

set -e  # Exit on any error

# Configuration
DEPLOY_PATH="/var/www"
APP_DIR="${DEPLOY_PATH}/micorCourses-backend"
BACKUP_DIR="${DEPLOY_PATH}/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
APP_NAME="micorCourses-backend"

echo "🚀 Starting deployment process..."

# Create directories if they don't exist
mkdir -p ${BACKUP_DIR}
mkdir -p ${APP_DIR}

# Create backup before deployment
echo "📦 Creating backup..."
if [ -d "${APP_DIR}" ] && [ "$(ls -A ${APP_DIR})" ]; then
    tar -czf ${BACKUP_DIR}/backup_${TIMESTAMP}.tar.gz -C ${DEPLOY_PATH} ${APP_NAME}
    echo "✅ Backup created: backup_${TIMESTAMP}.tar.gz"
    
    # Keep only last 5 backups
    ls -t ${BACKUP_DIR}/backup_*.tar.gz | tail -n +6 | xargs rm -f || true
else
    echo "⚠️  No existing deployment found, skipping backup"
fi

# Navigate to app directory
cd ${APP_DIR}

# Install/update dependencies
echo "📥 Installing dependencies..."
npm ci --production

# Ensure .env file exists
if [ ! -f "${APP_DIR}/.env" ]; then
    echo "⚠️  Warning: .env file not found!"
    echo "Please ensure environment variables are configured."
fi

# Restart application with PM2
echo "🔄 Restarting application..."
if pm2 list | grep -q "${APP_NAME}"; then
    pm2 restart ${APP_NAME}
else
    pm2 start src/server.js --name ${APP_NAME}
    pm2 save
fi

# Wait for application to start
echo "⏳ Waiting for application to start..."
sleep 5

# Health check
echo "🏥 Performing health check..."
MAX_RETRIES=5
RETRY_COUNT=0
HEALTH_CHECK_PASSED=false

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if curl -f http://localhost:4001/api/health > /dev/null 2>&1; then
        HEALTH_CHECK_PASSED=true
        break
    fi
    RETRY_COUNT=$((RETRY_COUNT + 1))
    echo "  Retry $RETRY_COUNT/$MAX_RETRIES..."
    sleep 3
done

if [ "$HEALTH_CHECK_PASSED" = true ]; then
    echo "✅ Deployment successful! Application is healthy."
    exit 0
else
    echo "❌ Health check failed after $MAX_RETRIES attempts."
    echo "🔄 Rolling back to previous version..."
    
    # Rollback logic
    LATEST_BACKUP=$(ls -t ${BACKUP_DIR}/backup_*.tar.gz 2>/dev/null | head -1)
    
    if [ -n "$LATEST_BACKUP" ]; then
        echo "📦 Restoring from backup: $(basename $LATEST_BACKUP)"
        cd ${DEPLOY_PATH}
        rm -rf ${APP_DIR}
        tar -xzf ${LATEST_BACKUP}
        cd ${APP_DIR}
        npm ci --production
        pm2 restart ${APP_NAME}
        echo "✅ Rollback completed."
    else
        echo "❌ No backup found for rollback!"
    fi
    
    exit 1
fi

