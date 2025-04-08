#!/bin/bash

sudo yum update -y
sudo yum install -y python3-pip
sudo pip3 install sqlalchemy flask flask-sqlalchemy flask-cors pymysql
sudo yum install -y python3 python3-pip python3-devel mysql-devel gcc
sudo pip3 install flask flask-sqlalchemy flask-cors pymysql





sudo systemctl daemon-reload
sudo systemctl enable userapp
sudo systemctl start userapp