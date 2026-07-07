# pfSense Firewall Setup Guide

## Prerequisites
- pfSense ISO (download from pfsense.org)
- 2 GB RAM allocated to VM
- 20 GB storage (dynamic)
- VirtualBox 6.1+

## Step 1: Create pfSense VM

| Setting | Value |
|---------|-------|
| Name | pfSense-Firewall |
| Type | BSD |
| Version | FreeBSD (64-bit) |
| RAM | 2048 MB (2 GB) |
| Storage | 20 GB (Dynamic) |

## Step 2: Configure Network Adapters

| Adapter | Attached To | Name | Purpose |
|---------|-------------|------|---------|
| Adapter 1 | NAT | - | WAN |
| Adapter 2 | Internal Network | LabNet-LAN | LAN |
| Adapter 3 | Internal Network | LabNet-DMZ | DMZ |

## Step 3: Install pfSense

1. Start the VM
2. Press **Enter** to accept defaults
3. Select **Install**
4. Keymap: Accept default (US)
5. Partitioning: **Auto (ZFS)**
6. Disk: Select the only disk (`vtbd0`)
7. ZFS Configuration: Accept defaults
8. When complete → Select **Reboot**
9. Remove the ISO: Devices → Optical Drives → Remove disk

## Step 4: Interface Assignment

1. Login: `root` / `pfsense`
2. Select option **1) Assign Interfaces**
3. VLANs: Type `n`
4. WAN Interface: Type `em0`
5. LAN Interface: Type `em1`
6. Optional 1 (DMZ): Type `em2`
7. Confirm: Type `y`

## Step 5: Set IP Addresses

### WAN (NAT)
- Select option **2) Set interface IP address**
- Interface: `1` (WAN)
- Configure via DHCP: Type `y`

### LAN
- Select option **2) Set interface IP address**
- Interface: `2` (LAN)
- Configure via DHCP: Type `n`
- IPv4 Address: `192.168.10.1`
- Subnet bit count: `24`
- Enable DHCP server: Type `y`
- Start address: `192.168.10.100`
- End address: `192.168.10.200`
- DNS: `8.8.8.8`

### DMZ (OPT1)
- Select option **2) Set interface IP address**
- Interface: `3` (OPT1)
- Configure via DHCP: Type `n`
- IPv4 Address: `192.168.20.1`
- Subnet bit count: `24`
- Enable DHCP server: Type `n`

## Step 6: Reboot

Select option **5) Reboot the system**

## Step 7: Access WebGUI

From Windows 11 VM: Open browser → `https://192.168.10.1`
- Login: `admin` / `pfsense`
