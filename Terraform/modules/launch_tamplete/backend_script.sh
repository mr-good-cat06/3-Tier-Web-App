#!/bin/bash

sudo yum update -y
sudo yum install -y python3-pip
sudo pip3 install sqlalchemy flask flask-sqlalchemy flask-cors pymysql
sudo yum install -y python3 python3-pip python3-devel mysql-devel gcc
sudo pip3 install flask flask-sqlalchemy flask-cors pymysql boto3


sudo tee -a /etc/systemd/system/userapp.service << EOF

[Service]
Environment="DB_USERNAME=${user}"
Environment="DB_PASSWORD=${pass}"
Environment="DB_ENDPOINT=${db_endpoint}"
Environment="DB_NAME=${db_name}"
EOF

# Reload systemd to recognize changes
sudo systemctl daemon-reload

# Restart the service to apply environment variables
sudo systemctl restart userapp

# Make sure the service is enabled on boot
sudo systemctl enable userapp