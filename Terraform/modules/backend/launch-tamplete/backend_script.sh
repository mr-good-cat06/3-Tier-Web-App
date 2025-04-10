#!/bin/bash

# Set up logging
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Starting backend setup script"

# Install required packages if needed
sudo yum update -y
sudo yum install -y python3-pip
sudo pip3 install sqlalchemy flask flask-sqlalchemy flask-cors pymysql
sudo yum install -y python3 python3-pip python3-devel mysql-devel gcc
sudo pip3 install flask flask-sqlalchemy flask-cors pymysql boto3


# Set environment variables for database connection
echo "Setting database environment variables"
echo "export DB_USERNAME='${user}'" >> /etc/environment
echo "export DB_PASSWORD='${pass}'" >> /etc/environment
echo "export DB_ENDPOINT='${db_endpoint}'" >> /etc/environment
echo "export DB_NAME='${db_name}'" >> /etc/environment

# Also add to profile.d for persistence across sessions
cat > /etc/profile.d/db_env.sh << 'EOL'
export DB_USERNAME='${user}'
export DB_PASSWORD='${pass}'
export DB_ENDPOINT='${db_endpoint}'
export DB_NAME='${db_name}'
EOL

# Make the script executable
chmod +x /etc/profile.d/db_env.sh

# Source the environment variables for the current session
source /etc/environment

# Alternative: If you want to get credentials from Secrets Manager instead
# of directly using the passed variables, uncomment this section
#echo "Retrieving database credentials from Secrets Manager"
#SECRET_VALUE=$(aws secretsmanager get-secret-value --secret-id ${secret_name} --region ${region} --query SecretString --output text)
#
#DB_USERNAME=$(echo $SECRET_VALUE | jq -r '.username')
#DB_PASSWORD=$(echo $SECRET_VALUE | jq -r '.password')
#
#echo "export DB_USERNAME='$DB_USERNAME'" >> /etc/environment
#echo "export DB_PASSWORD='$DB_PASSWORD'" >> /etc/environment
#source /etc/environment

# Make sure the backend service has these variables
if [ -f /etc/systemd/system/userapp.service ]; then
    echo "Updating backend service with environment variables"
    # Add Environment directives to the service file
    sed -i '/\[Service\]/a Environment="DB_USERNAME='${user}'"' /etc/systemd/system/userapp.service
    sed -i '/\[Service\]/a Environment="DB_PASSWORD='${pass}'"' /etc/systemd/system/userapp.service
    sed -i '/\[Service\]/a Environment="DB_ENDPOINT='${db_endpoint}'"' /etc/systemd/system/userapp.service
    sed -i '/\[Service\]/a Environment="DB_NAME='${db_name}'"' /etc/systemd/system/userapp.service
    
    # Reload systemd and restart the service
    systemctl daemon-reload
    systemctl restart userapp
fi

# Ensure backend is listening on all interfaces (not just localhost)
# This is critical for load balancer health checks to work
# Modify your application configuration if needed

echo "Backend setup completed"