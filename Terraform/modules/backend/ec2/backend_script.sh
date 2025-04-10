#!/bin/bash
export DB_USERNAME=${user}
export DB_PASSWORD=${pass}
export DB_ENDPOINT=${db_endpoint}
export DB_NAME=${db_name}

sudo yum update -y
sudo yum install -y python3-pip
sudo pip3 install sqlalchemy flask flask-sqlalchemy flask-cors pymysql
sudo yum install -y python3 python3-pip python3-devel mysql-devel gcc
sudo pip3 install flask flask-sqlalchemy flask-cors pymysql boto3

# Reload systemd to recognize changes
sudo systemctl daemon-reload

# Restart the service to apply environment variables
sudo systemctl restart userapp

# Make sure the service is enabled on boot
sudo systemctl enable userapp