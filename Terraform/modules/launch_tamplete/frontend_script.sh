#!/bin/bash

echo ""REACT_APP_API_URL=${backend_url}" > /usr/share/nginx/html/.env"

sudo dnf update -y
sudo dnf install -y nginx 
sudo systemctl enable nginx
sudo systemctl restart nginx
sudo chown -R nginx:nginx /usr/share/nginx/html