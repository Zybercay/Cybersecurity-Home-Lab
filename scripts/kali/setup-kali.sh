#!/bin/bash

# Kali Linux Initial Setup Script

echo "=== Kali Linux Setup Script ==="
echo "Starting at: $(date)"

# Update package list
echo "[1] Updating package list..."
sudo apt update

# Fix sources.list if needed
echo "[2] Verifying sources.list..."
if ! grep -q "kali-rolling" /etc/apt/sources.list; then
    echo "Adding Kali rolling repository..."
    echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" | sudo tee -a /etc/apt/sources.list
fi

# Full upgrade
echo "[3] Performing full upgrade..."
sudo apt full-upgrade -y

# Install additional tools
echo "[4] Installing additional tools..."
sudo apt install -y python3-pip metasploit-framework nmap

# Clean up
echo "[5] Cleaning up..."
sudo apt autoremove -y

# Configure network
echo "[6] Configuring network..."
sudo ip link set eth0 up 2>/dev/null || echo "eth0 already up"
sudo ip addr add 192.168.20.10/24 dev eth0 2>/dev/null || echo "IP already assigned"
sudo ip route add default via 192.168.20.1 dev eth0 2>/dev/null || echo "Route already exists"

# Verify connectivity
echo "[7] Testing connectivity..."
ping -c 2 192.168.20.1 && echo "✓ pfSense DMZ reachable" || echo "✗ pfSense DMZ not reachable"
ping -c 2 192.168.10.10 && echo "✓ Windows 11 reachable" || echo "✗ Windows 11 not reachable"
ping -c 2 8.8.8.8 && echo "✓ Internet reachable" || echo "✗ Internet not reachable"

echo ""
echo "=== Setup Complete ==="
echo "Kali IP: 192.168.20.10"
echo "Gateway: 192.168.20.1"
echo "Date: $(date)"
