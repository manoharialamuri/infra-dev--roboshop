#!/bin/bash

# Log everything
exec > /var/log/user-data.log 2>&1

echo "Starting OpenVPN setup..."

# Update system
yum update -y

# Install required packages
yum install -y ca-certificates wget net-tools gnupg

# Set hostname (optional)
hostnamectl set-hostname openvpn-server

# Download OpenVPN Access Server
cd /tmp
wget https://as-repository.openvpn.net/as-repo-amzn2.rpm

# Install OpenVPN repo
yum install -y ./as-repo-amzn2.rpm

# Install OpenVPN Access Server
yum install -y openvpn-as

# Start and enable service
systemctl start openvpnas
systemctl enable openvpnas

# Wait for service to initialize
sleep 20

# Set admin password
ADMIN_USER="openvpn"
ADMIN_PASS="Admin@123"   # 🔴 Change this in real usage

/usr/local/openvpn_as/scripts/sacli --user $ADMIN_USER --new_pass $ADMIN_PASS SetLocalPassword

# Enable routing (optional but useful)
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

# Print useful info
echo "-------------------------------------"
echo "OpenVPN Access Server Installed"
echo "Admin UI: https://<EC2-PUBLIC-IP>:943/admin"
echo "User UI : https://<EC2-PUBLIC-IP>:943"
echo "Username: $ADMIN_USER"
echo "Password: $ADMIN_PASS"
echo "-------------------------------------"