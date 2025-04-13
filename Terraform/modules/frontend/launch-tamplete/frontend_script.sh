#!/bin/bash
# Update packages and prepare Apache
sudo dnf update -y

# Move the static index.html file into Apache's web root
sudo mv /home/ec2-user/index.html /var/www/html/

# Create the JavaScript config file with the backend URL
cat <<EOF | sudo tee /var/www/html/config.js > /dev/null
window.CONFIG = {
  API_URL: "${backend_url}"
};
EOF

cat <<EOF | sudo tee /etc/httpd/conf.d/proxy.conf > /dev/null
ProxyPass "/api" "${backend_url}"
ProxyPassReverse "/api" "${backend_url}"
EOF




# Enable and start Apache web server
sudo systemctl enable httpd
sudo systemctl restart httpd