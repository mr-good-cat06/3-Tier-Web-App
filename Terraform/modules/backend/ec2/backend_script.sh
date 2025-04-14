#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Starting userapp setup script"

# Create mount directory
mkdir -p /mnt/backend

# Mount the EFS file system
mount -t efs -o tls ${fs_id}:/ /mnt/backend

# Create symlink for backward compatibility (optional)
ln -sf /mnt/backend/userapp /opt/userapp

# Set up environment variables the same way as before
cat > /etc/profile.d/db_env.sh << 'EOF'
export AWS_REGION='${region}'
export DB_SECRET_NAME='${secret_name}'
export DB_USERNAME='${db_username}'
export DB_PASSWORD='${db_password}'
export DB_ENDPOINT='${db_endpoint}'
export DB_NAME='${db_name}'
EOF

# Make the script executable
chmod +x /etc/profile.d/db_env.sh

# Add to /etc/environment for system-wide availability
echo "AWS_REGION='${region}'" >> /etc/environment
echo "DB_SECRET_NAME='${secret_name}'" >> /etc/environment
echo "DB_USERNAME='${db_username}'" >> /etc/environment
echo "DB_PASSWORD='${db_password}'" >> /etc/environment
echo "DB_ENDPOINT='${db_endpoint}'" >> /etc/environment
echo "DB_NAME='${db_name}'" >> /etc/environment

# Create systemd service file
cat > /etc/systemd/system/userapp.service << 'EOF'
[Unit]
Description=User Management API
After=network.target remote-fs.target

[Service]
User=ec2-user
WorkingDirectory=/mnt/backend/userapp
ExecStart=/usr/bin/python3 /mnt/backend/userapp/app.py
Restart=always
Environment="AWS_REGION=${region}"
Environment="DB_SECRET_NAME=${secret_name}"
Environment="DB_USERNAME=${db_username}"
Environment="DB_PASSWORD=${db_password}"
Environment="DB_ENDPOINT=${db_endpoint}"
Environment="DB_NAME=${db_name}"

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
sudo systemctl daemon-reexec
systemctl daemon-reload
systemctl enable userapp.service