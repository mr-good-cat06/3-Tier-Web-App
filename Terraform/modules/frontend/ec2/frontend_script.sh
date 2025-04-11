sudo dnf update -y


sudo mv /home/ec2-user/index.html /var/www/html


#!/bin/bash
# Create a JavaScript config file with the backend URL

cat > /var/www/html/config.js << EOF
window.CONFIG = {
  API_URL: "${backend_url}"
};
EOF

sudo systemctl enable httpd
sudo systemctl start httpd