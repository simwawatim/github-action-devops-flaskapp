#!/bin/bash
cd /home/ubuntu/demo-flask || exit
git pull origin main
source venv/bin/activate
pip install -r requirements.txt
pkill -f "python3 app.py" || true
nohup python3 app.py &
echo "App deployed successfully!"
