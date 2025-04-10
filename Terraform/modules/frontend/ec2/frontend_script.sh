#!/bin/bash

export REACT_APP_API_URL=${backend_url}

sudo dnf update -y
sudo dnf install -y nginx 
sudo systemctl enable nginx
sudo systemctl restart nginx
sudo chown -R nginx:nginx /usr/share/nginx/html