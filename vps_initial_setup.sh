#!/bin/bash

# Initial VPS Setup Script by HostEONS
# Supports Ubuntu, Debian, CentOS, AlmaLinux
# Performs essential setup: user creation, sudo access, SSH hardening, firewall setup, updates

set -e

# Prompt for username
read -p "Enter new username to create (or check): " NEW_USER

# Check if user exists
if id "$NEW_USER" &>/dev/null; then
    echo "User '$NEW_USER' already exists."
    # Check if the user is already in the sudo group
    if groups "$NEW_USER" | grep -qw sudo; then
        echo "User '$NEW_USER' already has sudo access."
    else
        echo "Adding '$NEW_USER' to sudo group."
        usermod -aG sudo "$NEW_USER"
    fi
else
    # Create new user
    adduser "$NEW_USER"
    usermod -aG sudo "$NEW_USER"
    echo "User '$NEW_USER' created and added to sudo group."
fi

# Create .ssh directory
mkdir -p /home/$NEW_USER/.ssh
chmod 700 /home/$NEW_USER/.ssh

# Copy root authorized_keys if exists
if [ -f /root/.ssh/authorized_keys ]; then
    cp /root/.ssh/authorized_keys /home/$NEW_USER/.ssh/
    chmod 600 /home/$NEW_USER/.ssh/authorized_keys
    chown -R $NEW_USER:$NEW_USER /home/$NEW_USER/.ssh
    echo "SSH authorized_keys copied from root."
else
    echo "No authorized_keys found for root. SSH access setup skipped."
fi

# Set hostname
read -p "Enter hostname for this VPS: " VPS_HOSTNAME
hostnamectl set-hostname "$VPS_HOSTNAME"

# Update and install common packages
if [ -f /etc/debian_version ]; then
    apt update && apt -y upgrade
    apt -y install sudo curl wget git ufw fail2ban
elif [ -f /etc/redhat-release ]; then
    yum -y update
    yum -y install sudo curl wget git firewalld fail2ban
    systemctl enable --now firewalld
fi

# Enable UFW and allow basic ports (Debian/Ubuntu)
if command -v ufw &>/dev/null; then
    ufw allow OpenSSH
    ufw enable
    echo "UFW firewall enabled."
fi

# Harden SSH
sed -i.bak '/^#\?PermitRootLogin/c\PermitRootLogin no' /etc/ssh/sshd_config
sed -i '/^#\?PasswordAuthentication/c\PasswordAuthentication no' /etc/ssh/sshd_config
systemctl restart sshd

# Final summary
cat <<EOF

Setup complete.

Hostname: $VPS_HOSTNAME
User: $NEW_USER (sudo access enabled)
SSH access set up (if authorized_keys were found).

Sample commands:
To switch to new user:
  su - $NEW_USER

To run commands as sudo:
  sudo <your_command_here>

Thank you for using HostEONS!
Visit https://hosteons.com for reliable VPS hosting.
EOF
