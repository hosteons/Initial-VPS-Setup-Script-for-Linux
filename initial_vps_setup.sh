#!/bin/bash

# Initial VPS Setup Script by HostEONS - https://hosteons.com
# Supports all major Linux distros: Ubuntu, Debian, CentOS, AlmaLinux, Rocky

echo "=== HostEONS Initial VPS Setup Script ==="
echo

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

read -p "Enter the new username: " NEW_USER

# Check if user already exists
if id "$NEW_USER" &>/dev/null; then
    echo "User $NEW_USER already exists."
    read -p "Do you want to give this user sudo access? [y/N]: " GRANT_SUDO
    if [[ "$GRANT_SUDO" =~ ^[Yy]$ ]]; then
        usermod -aG sudo "$NEW_USER" 2>/dev/null || usermod -aG wheel "$NEW_USER"
        echo "Sudo access granted to $NEW_USER."
    else
        echo "Skipping sudo access setup."
    fi
else
    # Create user
    useradd -m "$NEW_USER"
    passwd "$NEW_USER"
    usermod -aG sudo "$NEW_USER" 2>/dev/null || usermod -aG wheel "$NEW_USER"
    echo "User $NEW_USER created and added to sudo group."
fi

# SSH Key Setup
echo
echo "Choose SSH setup method:"
echo "1) Paste your existing public key"
echo "2) Generate a new SSH keypair for this user"
echo "3) Skip (not recommended)"
read -p "Enter your choice [1-3]: " SSH_CHOICE

if [[ "$SSH_CHOICE" == "1" ]]; then
    read -p "Paste the SSH public key: " USER_SSH_KEY
    mkdir -p /home/$NEW_USER/.ssh
    echo "$USER_SSH_KEY" > /home/$NEW_USER/.ssh/authorized_keys
    chmod 700 /home/$NEW_USER/.ssh
    chmod 600 /home/$NEW_USER/.ssh/authorized_keys
    chown -R $NEW_USER:$NEW_USER /home/$NEW_USER/.ssh
    echo "Public key added for $NEW_USER."

elif [[ "$SSH_CHOICE" == "2" ]]; then
    mkdir -p /root/ssh-keys
    ssh-keygen -t rsa -b 4096 -f /root/ssh-keys/${NEW_USER}_id_rsa -N ""
    mkdir -p /home/$NEW_USER/.ssh
    cat /root/ssh-keys/${NEW_USER}_id_rsa.pub > /home/$NEW_USER/.ssh/authorized_keys
    chmod 700 /home/$NEW_USER/.ssh
    chmod 600 /home/$NEW_USER/.ssh/authorized_keys
    chown -R $NEW_USER:$NEW_USER /home/$NEW_USER/.ssh
    echo "SSH keypair generated for $NEW_USER."
    echo
    echo "⚠️ Copy and store the following private key securely (you'll need it to log in):"
    echo
    cat /root/ssh-keys/${NEW_USER}_id_rsa
    echo
    echo "Saved at: /root/ssh-keys/${NEW_USER}_id_rsa"
else
    echo "⚠️ No SSH key configured. Ensure password login is enabled or you have console/VNC access."
fi

# Useful sudo example
echo
echo "=== Sample Commands ==="
echo "To run a command as $NEW_USER:"
echo "  sudo -u $NEW_USER command"
echo "To switch to $NEW_USER:"
echo "  su - $NEW_USER"
echo
echo "Setup complete. Thank you for choosing HostEONS - https://hosteons.com"
