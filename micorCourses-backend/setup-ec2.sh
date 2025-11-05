# EC2 Initial Setup Script

Run this script on a fresh EC2 instance to set up the environment.

## Usage

```bash
# On EC2 instance
curl -o setup-ec2.sh https://raw.githubusercontent.com/YOUR_REPO/setup-ec2.sh
chmod +x setup-ec2.sh
./setup-ec2.sh
```

Or copy and paste the script contents directly:

```bash
#!/bin/bash
set -e

echo "🚀 Starting EC2 setup..."

# Update system
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Node.js 18.x
echo "📥 Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Verify Node.js installation
node --version
npm --version

# Install PM2
echo "📥 Installing PM2..."
sudo npm install -g pm2

# Install Nginx
echo "📥 Installing Nginx..."
sudo apt install -y nginx

# Install Git
echo "📥 Installing Git..."
sudo apt install -y git

# Install build essentials
echo "📥 Installing build tools..."
sudo apt install -y build-essential

# Install Certbot for SSL
echo "📥 Installing Certbot..."
sudo apt install -y certbot python3-certbot-nginx

# Create application directories
echo "📂 Creating directories..."
sudo mkdir -p /var/www/micorCourses-backend
sudo mkdir -p /var/www/backups
sudo chown -R ubuntu:ubuntu /var/www

# Create logs directory
mkdir -p /var/www/micorCourses-backend/logs

# Setup PM2 startup script
echo "⚙️  Configuring PM2..."
pm2 startup | grep "sudo" | bash || true

# Configure firewall (UFW)
echo "🔥 Configuring firewall..."
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw allow 4001/tcp
sudo ufw --force enable

echo "✅ EC2 setup completed!"
echo ""
echo "Next steps:"
echo "1. Configure .env file: cd /var/www/micorCourses-backend && nano .env"
echo "2. Deploy your application"
echo "3. Configure Nginx: sudo nano /etc/nginx/sites-available/micorCourses-backend"
echo "4. Setup SSL: sudo certbot --nginx -d yourdomain.com"

