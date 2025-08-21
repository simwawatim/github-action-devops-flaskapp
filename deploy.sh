#!/bin/bash

# Correct project path on your server
cd /home/ubuntu/erp-project/github-action-devops-flaskapp || exit

# Pull latest changes
git reset --hard HEAD
git clean -fd
git pull origin main

# Activate virtual environment
source env/bin/activate   # or venv/bin/activate if your venv folder is named venv
pip install --upgrade pip
pip install -r requirements.txt
deactivate

# Restart Flask service
sudo systemctl restart flask-app.service

echo "Deployment completed successfully!"
