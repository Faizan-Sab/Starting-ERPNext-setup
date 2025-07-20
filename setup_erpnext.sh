#!/bin/bash

echo -e "\n🟢 Starting ERPNext setup..."

# Update package lists
echo -e "\n🔄 Updating apt..."
sudo apt update || echo "❌ Failed to update apt"

# Install sudo if needed
echo -e "\n🔧 Installing sudo if missing..."
apt-get install -y sudo || echo "❌ Failed to install sudo"

# Install system dependencies
echo -e "\n📦 Installing system packages..."
sudo apt install -y python3-dev python3-pip python3.10-venv build-essential \
    mariadb-server redis-server curl nginx software-properties-common \
    libffi-dev libssl-dev wkhtmltopdf git xvfb libmysqlclient-dev \
    libjpeg-dev liblcms2-dev libblas-dev libatlas-base-dev \
    libpq-dev libtiff-dev libwebp-dev libxrender1 libxext6 \
    xfonts-base xfonts-75dpi libfontconfig1 supervisor || echo "❌ Failed to install dependencies"

# Enable and start Supervisor (fallback to direct if systemd fails)
echo -e "\n🛠️ Setting up Supervisor..."

if command -v systemctl >/dev/null 2>&1; then
    sudo systemctl enable supervisor || echo "❌ Failed to enable Supervisor"
    sudo systemctl start supervisor || echo "❌ Failed to start Supervisor"
else
    echo "⚠️ Systemd not available, trying direct start"
    sudo supervisord -c /etc/supervisor/supervisord.conf || echo "❌ Failed to start supervisord manually"
fi

# Show Supervisor status (optional)
sudo supervisorctl status || echo "❌ Supervisor status check failed"

# Navigate to Frappe bench directory
BENCH_DIR="/cloudclusters/erpnext/frappe-bench"
echo -e "\n📂 Checking bench directory: $BENCH_DIR"
if [ -d "$BENCH_DIR" ]; then
    cd "$BENCH_DIR" || echo "❌ Failed to enter $BENCH_DIR"
else
    echo "⚠️ Directory $BENCH_DIR not found. Skipping bench update."
fi

# Update bench
echo -e "\n📈 Updating bench..."
if command -v bench >/dev/null 2>&1; then
    bench update --reset || echo "❌ Bench update failed"
else
    echo "❌ Bench command not found. Skipping bench update."
fi

# Start bench in background (dev mode)
echo -e "\n🚀 Starting bench (development mode)..."
bench start &

# Restart Supervisor services
echo -e "\n🔁 Restarting Supervisor services..."
sudo supervisorctl restart all || echo "❌ Failed to restart Supervisor services"

# Set password for erpnext user (optional)
echo -e "\n🔐 Setting password for 'erpnext' user..."
if id "erpnext" >/dev/null 2>&1; then
    echo "erpnext:your_secure_password" | sudo chpasswd || echo "❌ Failed to set password"
    echo "✅ Password set for 'erpnext'"
else
    echo "⚠️ User 'erpnext' does not exist, skipping password setup."
fi

echo -e "\n✅ ERPNext setup script finished (some errors may have occurred)."
