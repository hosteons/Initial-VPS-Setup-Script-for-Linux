# Initial VPS Setup Script for Linux

This script helps you quickly prepare a secure and usable Linux VPS for first use. Whether you're setting up a VPS from HostEONS or elsewhere, this script will streamline the process with automation and best practices.

## Features

- Creates a new user with sudo privileges
- Checks if user already exists and updates sudo access if needed
- Disables root SSH login
- Enables UFW firewall with basic rules
- Sets up SSH key authentication
- Supports Ubuntu, Debian, CentOS, AlmaLinux, and Rocky Linux
- Provides guidance for using sudo access after setup

## Usage

```bash
wget https://raw.githubusercontent.com/hosteons/vps-initial-setup/main/vps_initial_setup.sh
chmod +x vps_initial_setup.sh
sudo ./vps_initial_setup.sh
```

You'll be prompted to enter:
- A username
- SSH public key for secure access
- Password (optional)
- Whether to disable root login

## Example Commands After Setup

```bash
# Switch to the new user
su - yourusername

# Run commands with sudo
sudo apt update
sudo yum install nano
```

## Why Use This Script?

Setting up a VPS manually can be time-consuming and error-prone. This script automates the essential hardening and configuration steps so you can start deploying your applications quickly and safely — especially recommended for VPS customers at [HostEONS](https://hosteons.com).

## About HostEONS

HostEONS offers blazing-fast KVM VPS, VDS, and hybrid servers with 10Gbps ports, IPv6 support, and global locations like the US, Germany, and France. Learn more at:

- 🌐 Website: [https://hosteons.com](https://hosteons.com)
- 📩 Support: [https://my.hosteons.com](https://my.hosteons.com)
- 📣 Twitter: [https://x.com/hosteonscom](https://x.com/hosteonscom)
- 📘 Facebook: [https://facebook.com/HostEons](https://facebook.com/HostEons)

## Disclaimer

Use this script at your own risk. It is designed to assist with VPS setup and assumes a fresh system. Review changes before applying to production environments.