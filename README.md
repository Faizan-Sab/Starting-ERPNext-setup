# ERPNext Setup

A comprehensive setup script and documentation for deploying an ERPNext instance with Frappe bench, Supervisor, and all required dependencies.

## Overview

This repository provides an automated setup script that configures ERPNext with proper process management, database connections, and web server configuration. The script handles the complete deployment process from dependency installation to service configuration.

## Prerequisites

Before running the setup script, ensure your system meets the following requirements:

- **Operating System**: Ubuntu 18.04 LTS or later (recommended: Ubuntu 20.04/22.04 LTS)
- **System Access**: Root or sudo privileges required
- **Hardware Requirements**:
  - Minimum 2GB RAM (4GB recommended)
  - At least 10GB free disk space
  - Stable internet connection for package downloads

### Required Dependencies

The following components will be installed/configured by the setup script:
- MariaDB Server (database backend)
- Redis Server (caching and session storage)
- Node.js and npm (JavaScript runtime and package manager)
- Python 3.8+ with pip (application runtime)
- Frappe Framework and ERPNext application
- Nginx (web server and reverse proxy)
- Supervisor (process management)

## Installation

### Step 1: Download the Repository

```bash
git clone https://github.com/your-username/ERPNext-Setup.git
cd ERPNext-Setup
```

### Step 2: Make Script Executable and Run

```bash
chmod +x setup_erpnext.sh
./setup_erpnext.sh
```

The script will automatically:
1. Update system packages
2. Install all required dependencies
3. Configure MariaDB with proper settings
4. Set up Redis server
5. Install Node.js and Python dependencies
6. Create and configure Frappe bench
7. Install ERPNext application
8. Configure Nginx and Supervisor
9. Start all services

## Post-Installation

### Default Installation Path
ERPNext and Frappe bench are installed in: `/cloudclusters/erpnext/frappe-bench`

### Accessing ERPNext
After successful installation, access your ERPNext instance at:
- **Local access**: `http://localhost:8000` or `http://your-server-ip:8000`
- **Production access**: `http://your-domain.com` (after domain configuration)

### Default Credentials
The script will prompt you to create an administrator account during setup. If using default settings:
- **Administrator Email**: Set during installation
- **Password**: Set during installation

## Configuration

### Site Configuration
To create additional sites or modify existing ones:

```bash
cd /cloudclusters/erpnext/frappe-bench
bench new-site your-site-name.com
bench install-app erpnext --site your-site-name.com
```

### Service Management
Control ERPNext services using Supervisor:

```bash
# Start all services
sudo supervisorctl start all

# Stop all services
sudo supervisorctl stop all

# Restart specific service
sudo supervisorctl restart frappe-bench-web

# Check service status
sudo supervisorctl status
```

### Database Access
Access MariaDB console:
```bash
mysql -u root -p
```

## Troubleshooting

### Common Issues

**Port 8000 already in use**:
```bash
sudo lsof -i :8000
sudo kill -9 <PID>
```

**Permission issues**:
```bash
cd /cloudclusters/erpnext/frappe-bench
sudo chown -R $USER:$USER .
```

**Service not starting**:
```bash
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start all
```

### Log Files
Check logs for troubleshooting:
- ERPNext logs: `/cloudclusters/erpnext/frappe-bench/logs/`
- Supervisor logs: `/var/log/supervisor/`
- Nginx logs: `/var/log/nginx/`

### Getting Help
If you encounter issues:
1. Check the log files mentioned above
2. Verify all services are running: `sudo supervisorctl status`
3. Ensure all dependencies are properly installed
4. Check the [ERPNext Community Forum](https://discuss.erpnext.com/)

## Maintenance

### Regular Updates
Keep your ERPNext installation updated:

```bash
cd /cloudclusters/erpnext/frappe-bench
bench update --requirements
```

### Backup
Create regular backups:
```bash
bench --site all backup --with-files
```

### Security
- Change default passwords immediately after installation
- Configure SSL certificates for production use
- Set up firewall rules to restrict access
- Regular security updates for the operating system

## Support

For additional support and documentation:
- [Official ERPNext Documentation](https://docs.erpnext.com/)
- [Frappe Framework Documentation](https://frappeframework.com/docs)
- [Community Forum](https://discuss.erpnext.com/)

## License

This setup script is provided as-is for educational and deployment purposes. Please refer to ERPNext and Frappe's respective licenses for usage terms.
