# Kali Linux Setup Guide

## Prerequisites
- Kali Linux VirtualBox OVA (download from kali.org)
- 4 GB RAM allocated to VM
- 2 CPU cores
- VirtualBox 6.1+

## Step 1: Import Kali OVA

1. Open VirtualBox → **File → Import Appliance**
2. Browse to your downloaded Kali OVA file
3. Review settings:
   - **Name**: Kali-Attacker
   - **RAM**: 4096 MB (4 GB)
   - **CPU**: 2 cores
4. Click **Import**
5. Wait for import to complete (5-10 minutes)

## Step 2: Initial Kali Configuration

1. Start the Kali VM
2. Default login: `kali` / `kali`
3. Open Terminal and run:

```bash
# Update package list
sudo apt update

# Full upgrade
sudo apt full-upgrade -y

# Install additional tools
sudo apt install -y python3-pip metasploit-framework nmap
```

## Step 3: Network Configuration

```bash
# Bring interface up
sudo ip link set eth0 up

# Assign static IP
sudo ip addr add 192.168.20.10/24 dev eth0

# Set default gateway
sudo ip route add default via 192.168.20.1 dev eth0

# Verify connectivity
ping -c 4 192.168.20.1
ping -c 4 192.168.10.10
ping -c 4 8.8.8.8
```

## Step 4: Take Snapshot

VirtualBox → Machine → Take Snapshot
- **Name**: Kali-Clean-Setup
- **Description**: Fresh Kali with updates and tools
