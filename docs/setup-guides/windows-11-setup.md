# Windows 11 Pro Setup Guide

## Prerequisites
- Windows 11 Pro ISO (download from Microsoft)
- 8 GB RAM allocated to VM
- 100 GB disk space (dynamic)
- VirtualBox 6.1+

## Step 1: Create VM

### VirtualBox Configuration

| Setting | Value |
|---------|-------|
| Name | Windows11-Target |
| Type | Microsoft Windows |
| Version | Windows 11 (64-bit) |
| RAM | 8192 MB (8 GB) |
| Storage | 100 GB (Dynamic) |

### System Settings
- **Motherboard**: Enable EFI, Enable TPM 2.0
- **Processor**: 2-4 Cores, Enable PAE/NX
- **Acceleration**: Enable VT-x/AMD-V, Nested Paging

### Display Settings
- Video Memory: 256 MB
- Enable 3D Acceleration
- Graphics Controller: VBoxSVGA

## Step 2: Install Windows 11

### Installation Process

1. **Boot from ISO**
   - Attach Windows 11 ISO to optical drive
   - Start VM

2. **Language Selection**
   - Language: English (United States)
   - Click Next

3. **Product Key**
   - Select "I don't have a product key"

4. **Edition Selection**
   - Windows 11 Pro
   - Click Next

5. **Installation Type**
   - Custom: Install Windows only (advanced)

6. **Disk Partition**
   - Select unallocated space (100 GB)
   - Click Next

### Bypass Internet Requirement

```cmd
# When prompted for network connection:
Shift + F10 → OOBE\BYPASSNRO

# VM will restart automatically
# After restart, click "I don't have internet"
# Continue with limited setup
```

### Local Account Setup

| Field | Value |
|-------|-------|
| Username | LabUser |
| Password | Password123! |
| Security Questions | Any (not used) |

## Step 3: Initial Configuration

### Disable Windows Defender (Temporary)

```powershell
# Open PowerShell as Administrator
# 1. Disable Real-time Protection
Set-MpPreference -DisableRealtimeMonitoring $true

# 2. Disable Network Protection
Set-MpPreference -EnableNetworkProtection Disabled

# 3. Disable Cloud Protection
Set-MpPreference -CloudBlockLevel 0

# 4. Disable Behavior Monitoring
Set-MpPreference -EnableBehaviorMonitoring $false

# 5. Disable Script Scanning
Set-MpPreference -DisableScriptScanning $true

# 6. Disable Block at First Sight
Set-MpPreference -EnableBlockAtFirstSeen $false

# 7. Disable PUA Protection
Set-MpPreference -PUAProtection Disabled

# 8. Disable SmartScreen
Set-MpPreference -EnableSmartScreen $false

# 9. Exclude Downloads folder
Add-MpPreference -ExclusionPath "C:\Users\LabUser\Downloads"

# 10. Exclude file extensions
Add-MpPreference -ExclusionExtension ".exe"
Add-MpPreference -ExclusionExtension ".ps1"
```

### Disable Windows Firewall

```powershell
# Disable firewall for all profiles
netsh advfirewall set allprofiles state off

# Verify firewall is off
netsh advfirewall show allprofiles
```

### Configure ICMP Rule (For Testing)

```powershell
# Allow ICMP Echo Request
New-NetFirewallRule -DisplayName "Allow ICMP Echo Request" `
    -Direction Inbound `
    -Protocol ICMPv4 `
    -Action Allow
```

## Step 4: Install Critical Tools

### Visual C++ Redistributable

```powershell
# Download and install
Invoke-WebRequest -Uri "https://aka.ms/vs/17/release/vc_redist.x64.exe" `
    -OutFile "$env:TEMP\vc_redist.x64.exe"

Start-Process -FilePath "$env:TEMP\vc_redist.x64.exe" -ArgumentList "/install /quiet" -Wait
```

### Sysmon Installation

```powershell
# Create Sysmon directory
New-Item -Path "C:\Sysmon" -ItemType Directory

# Download Sysmon
Invoke-WebRequest -Uri "https://download.sysinternals.com/files/Sysmon.zip" `
    -OutFile "C:\Sysmon\Sysmon.zip"

# Extract Sysmon
Expand-Archive -Path "C:\Sysmon\Sysmon.zip" -DestinationPath "C:\Sysmon\"

# Download Olaf Hartong's configuration
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/olafhartong/sysmon-modular/main/sysmonconfig.xml" `
    -OutFile "C:\Sysmon\sysmonconfig.xml"

# Install Sysmon
cd C:\Sysmon
.\Sysmon64.exe -i .\sysmonconfig.xml
```

### Splunk Enterprise Installation

```powershell
# Download Splunk
# Note: Manual download required due to authentication
# Go to: https://www.splunk.com/en_us/download/splunk-enterprise.html

# Install Splunk (Manual)
# Download .msi installer from website
# Run installer with default settings

# Setup Credentials
$splunkUser = "admin"
$splunkPass = "SecureLab2024!"

# Configure Inputs
# Edit: C:\Program Files\Splunk\etc\system\local\inputs.conf
```

## Step 5: Network Configuration

### Static IP Assignment

| Setting | Value |
|---------|-------|
| IP Address | 192.168.10.10 |
| Subnet Mask | 255.255.255.0 |
| Gateway | 192.168.10.1 |
| DNS | 8.8.8.8 |

```powershell
# Verify Network Configuration
ipconfig /all

# Test Connectivity
ping 192.168.10.1  # Should succeed
ping 8.8.8.8       # Should succeed
```

## Step 6: Take Snapshot

```powershell
# VirtualBox: Machine → Take Snapshot
Name: Windows11-Clean-Setup
Description: Fresh Windows 11 with Splunk and Sysmon installed
```

## Troubleshooting

### Common Issues

1. **Windows 11 Installation Fails**
   - Ensure TPM 2.0 and EFI are enabled
   - Check virtualization settings in BIOS

2. **Network Not Working**
   - Verify Internal Network name matches pfSense
   - Check pfSense is running first
   - Restart network services

3. **Splunk Not Starting**
   - Check Windows services (services.msc)
   - Verify ports not in use
   - Check logs: C:\Program Files\Splunk\var\log\splunk
