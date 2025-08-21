#!/bin/bash

# Go to project directory
cd /home/ubuntu/erp-project/github-action-devops-flaskapp || exit

# Reset any local changes and pull latest code
git reset --hard HEAD
git clean -fd
git pull origin main

# Activate virtual environment and install dependencies
source env/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
deactivate

# Restart Flask via systemd
sudo systemctl restart flask-app.service

echo "App deployed successfully!"
