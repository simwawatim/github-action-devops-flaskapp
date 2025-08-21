#!/bin/bash

# Function to print timestamped messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log "Starting deployment..."

# Project directory
PROJECT_DIR="/home/ubuntu/erp-project/github-action-devops-flaskapp"

# Go to project directory
cd "$PROJECT_DIR" || { log "Failed to cd into $PROJECT_DIR"; exit 1; }
log "Changed directory to $PROJECT_DIR"

# Reset local changes and pull latest code
log "Resetting local changes and pulling latest code..."
git reset --hard HEAD
git clean -fd
git pull origin main || { log "Git pull failed"; exit 1; }
log "Code updated from GitHub"

# Check if virtual environment exists and is valid
if [ ! -f "$PROJECT_DIR/env/bin/activate" ] || [ ! -x "$PROJECT_DIR/env/bin/python" ]; then
    log "Virtual environment missing or broken, creating a new one..."
    rm -rf env
    python3 -m venv env || { log "Failed to create virtual environment"; exit 1; }
    log "Virtual environment created"
fi

# Activate virtual environment
log "Activating virtual environment..."
source env/bin/activate || { log "Failed to activate virtual environment"; exit 1; }

# Debug info
log "Virtual environment PATH: $VIRTUAL_ENV"
log "Which python: $(which python)"
log "Which pip: $(which pip)"
log "Python version: $(python --version)"

# Upgrade pip and install dependencies
log "Installing/upgrading dependencies..."
"$PROJECT_DIR/env/bin/pip" install --upgrade pip || { log "Failed to upgrade pip"; deactivate; exit 1; }
"$PROJECT_DIR/env/bin/pip" install -r requirements.txt || { log "Pip install failed"; deactivate; exit 1; }

log "Dependencies installed successfully"
deactivate
log "Virtual environment deactivated"

# Restart Flask service
log "Restarting Flask service..."
sudo systemctl restart flask-app.service || { log "Failed to restart Flask service"; exit 1; }
log "Flask service restarted successfully"

log "Deployment completed!"
