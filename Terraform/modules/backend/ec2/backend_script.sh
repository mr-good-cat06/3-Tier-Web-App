#!/bin/bash

sudo pip3 install boto3
# Set up logging
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Starting userapp setup script"

# Set environment variables for the system
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

# Also add to /etc/environment for system-wide availability
echo "AWS_REGION='${region}'" >> /etc/environment
echo "DB_SECRET_NAME='${secret_name}'" >> /etc/environment
echo "DB_USERNAME='${db_username}'" >> /etc/environment
echo "DB_PASSWORD='${db_password}'" >> /etc/environment
echo "DB_ENDPOINT='${db_endpoint}'" >> /etc/environment
echo "DB_NAME='${db_name}'" >> /etc/environment

# If you're using systemd to run your application, add the variables there too
if [ -f /etc/systemd/system/userapp.service ]; then
    echo "Adding environment variables to systemd service"
    # Add Environment directives to the service file
    sed -i '/\[Service\]/a Environment="AWS_REGION=${region}"' /etc/systemd/system/userapp.service
    sed -i '/\[Service\]/a Environment="DB_SECRET_NAME=${secret_name}"' /etc/systemd/system/userapp.service
    sed -i '/\[Service\]/a Environment="DB_USERNAME=${db_username}"' /etc/systemd/system/userapp.service
    sed -i '/\[Service\]/a Environment="DB_PASSWORD=${db_password}"' /etc/systemd/system/userapp.service
    sed -i '/\[Service\]/a Environment="DB_ENDPOINT=${db_endpoint}"' /etc/systemd/system/userapp.service
    sed -i '/\[Service\]/a Environment="DB_NAME=${db_name}"' /etc/systemd/system/userapp.service
    
    # Reload systemd and restart the service
    sudo systemctl daemon-reexec
    systemctl daemon-reload
    systemctl enable userapp
    systemctl start userapp

fi

# Ensure the application is properly configured to listen on all interfaces for LB health checks
# Add any application-specific configurations here

echo "Backend setup completed"