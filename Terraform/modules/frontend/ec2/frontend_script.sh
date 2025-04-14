cat <<EOF | sudo tee /var/www/html/config.js > /dev/null
window.CONFIG = {API_URL: "${backend_url}"};
EOF

sudo chown apache:apache /var/www/html/config.js
sudo chmod 644 /var/www/html/config.js

cat <<EOF | sudo tee /etc/systemd/system/conf.d/proxy.conf > /dev/null
# Existing modules
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_http_module modules/mod_proxy_http.so

# S3 proxy for everything else
ProxyPass "/" "${bucket_url}"
ProxyPassReverse "/" "${bucket_url}"

# Existing backend proxy configuration
ProxyPass "/api" "${backend_url}"
ProxyPassReverse "/api" "${backend_url}"

# Local configuration files (this comes first to take precedence)
# Don't proxy these specific files
ProxyPass "/config.js" "!"
Alias "/config.js" "/var/www/html/config.js"
EOF

sudo systemctl enable httpd
sudo systemctl start httpd