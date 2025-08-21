#!/bin/bash

# Function to print timestamped messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log "Starting deployment..."

# Go to project directory
PROJECT_DIR="/home/ubuntu/erp-project/github-action-devops-flaskapp"
cd $PROJECT_DIR || { log "Failed to cd into $PROJECT_DIR"; exit 1; }
log "Changed directory to $PROJECT_DIR"

# Reset local changes and pull latest code
log "Resetting local changes and pulling latest code..."
git reset --hard HEAD
git clean -fd
git pull origin main || { log "Git pull failed"; exit 1; }
log "Code updated from GitHub"

# Activate virtual environment and install dependencies
log "Activating virtual environment..."
source env/bin/activate || { log "Failed to activate virtual environment"; exit 1; }
log "Installing/upgrading dependencies..."
pip install --upgrade pip
pip install -r requirements.txt || { log "Pip install failed"; deactivate; exit 1; }
deactivate
log "Dependencies installed and virtual environment deactivated"

# Restart Flask service via systemd
log "Restarting Flask service..."
sudo systemctl restart flask-app.service || { log "Failed to restart Flask service"; exit 1; }
log "Flask service restarted successfully"

log "Deployment completed!"
