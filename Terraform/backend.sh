#!/bin/bash

# Set up logging
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Starting backend setup script"

# Set environment variables for the system
cat > /etc/profile.d/db_env.sh << 'EOF'
export AWS_REGION='ap-northeast-1'
export DB_SECRET_NAME='db-credentials1'
export DB_USERNAME='admin'
export DB_PASSWORD='Hello123'
export DB_ENDPOINT='database-1.crmigsmu6rtx.ap-northeast-1.rds.amazonaws.com'
export DB_NAME='database-1'
EOF

# Make the script executable
chmod +x /etc/profile.d/db_env.sh

# Also add to /etc/environment for system-wide availability
echo "AWS_REGION='ap-northeast-1'" >> /etc/environment
echo "DB_SECRET_NAME='db-credentials1'" >> /etc/environment
echo "DB_USERNAME='admin'" >> /etc/environment
echo "DB_PASSWORD='Hello123'" >> /etc/environment
echo "DB_ENDPOINT='database-1.crmigsmu6rtx.ap-northeast-1.rds.amazonaws.com'" >> /etc/environment
echo "DB_NAME='database-1'" >> /etc/environment

# If you're using systemd to run your application, add the variables there too
if [ -f /etc/systemd/system/userapp.service ]; then
    echo "Adding environment variables to systemd service"
    # Add Environment directives to the service file
    sed -i '/\[Service\]/a Environment="AWS_REGION=ap-northeast-1"' /etc/systemd/system/userapp.service
    sed -i '/\[Service\]/a Environment="DB_SECRET_NAME=db-credentials1"' /etc/systemd/system/userapp.service
    sed -i '/\[Service\]/a Environment="DB_USERNAME=admin"' /etc/systemd/system/userapp.service
    sed -i '/\[Service\]/a Environment="DB_PASSWORD=Hello123"' /etc/systemd/system/userapp.service
    sed -i '/\[Service\]/a Environment="DB_ENDPOINT=database-1.crmigsmu6rtx.ap-northeast-1.rds.amazonaws.com"' /etc/systemd/system/userapp.service
    sed -i '/\[Service\]/a Environment="DB_NAME=database-1"' /etc/systemd/system/userapp.service
    
    # Reload systemd and restart the service
    systemctl daemon-reload
    systemctl enable userapp
    systemctl start userapp
fi

# Ensure the application is properly configured to listen on all interfaces for LB health checks
# Add any application-specific configurations here

echo "Backend setup completed"




#!/bin/bash
python3 -c "
from sqlalchemy import create_engine
engine = create_engine('mysql+pymysql://admin:Hello123@database-1.crmigsmu6rtx.ap-northeast-1.rds.amazonaws.com/database-1')
try:
    connection = engine.connect()
    print('Database connection successful')
except Exception as e:
    print(f'Database connection failed: {e}')
"