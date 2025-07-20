#!/bin/bash
set -e

echo "Starting ERPNext setup..."

# Update package lists
sudo apt-get update || { echo "Failed to update package lists"; exit 1; }

# Install sudo (in case it's not already installed)
apt-get install -y sudo || { echo "Failed to install sudo"; exit 1; }

# Install Python 3
sudo apt-get install -y python3 python3-pip || { echo "Failed to install Python 3"; exit 1; }

# Install Supervisor
sudo apt install -y supervisor || { echo "Failed to install Supervisor"; exit 1; }

# Enable and start Supervisor
sudo systemctl enable supervisor || { echo "Failed to enable Supervisor"; exit 1; }
sudo systemctl start supervisor || { echo "Failed to start Supervisor"; exit 1; }

# Check Supervisor status
sudo supervisorctl status || { echo "Supervisor status check failed"; exit 1; }

# Navigate to ERPNext bench directory
if [ -d "/cloudclusters/erpnext/frappe-bench" ]; then
    cd /cloudclusters/erpnext/frappe-bench || { echo "Failed to navigate to frappe-bench"; exit 1; }
else
    echo "Directory /cloudclusters/erpnext/frappe-bench does not exist. Please set up ERPNext first."
    exit 1
fi

# Update bench (assuming bench is installed)
if command -v bench >/dev/null 2>&1; then
    bench update --reset || { echo "Bench update failed"; exit 1; }
else
    echo "Bench command not found. Please install Frappe bench."
    exit 1
fi

# Start bench (in development mode)
bench start &

# Restart Supervisor services
sudo supervisorctl restart all || { echo "Failed to restart Supervisor services"; exit 1; }

# Set password for erpnext user non-interactively
if id "erpnext" >/dev/null 2>&1; then
    echo "erpnext:your_secure_password" | sudo chpasswd || { echo "Failed to set password for erpnext user"; exit 1; }
    echo "Password for erpnext user set successfully."
else
    echo "User 'erpnext' does not exist. Skipping password setup."
fi

echo "ERPNext setup completed successfully!"
