# Incident Response Playbook: Reverse Shell Detection

## Overview

This playbook outlines the procedures for detecting, containing, and eradicating a Meterpreter reverse shell infection in the lab environment.

## 1. DETECTION

### Splunk Alerts

| Alert Name | Search Query | Trigger |
|------------|--------------|---------|
| Reverse Shell Detection | index=endpoint (EventCode=4688 CommandLine="*whoami*" OR "*net user*") OR (EventCode=3 DestinationPort=4444) | Results > 0 |
| Suspicious Command | index=endpoint CommandLine="*whoami*" OR "*net user*" | Results > 0 |
| Malicious Network Connection | index=endpoint EventCode=3 DestinationPort=4444 | Results > 0 |

### Manual Investigation

```spl
# 1. Check for suspicious process creation
index=endpoint EventCode=4688
| table _time, User, CommandLine, NewProcessName
| search CommandLine="*.exe" OR CommandLine="*.ps1"
| sort -_time

# 2. Check for network connections
index=endpoint EventCode=3 sourcetype=XmlWinEventLog
| table _time, User, SourceAddress, DestinationAddress, DestinationPort
| search DestinationPort=4444

# 3. Check for suspicious downloads
index=endpoint EventCode=4688 CommandLine="*http://192.168.20.10*"

# 4. Check for PowerShell execution
index=endpoint EventCode=4688 CommandLine="*powershell*" OR "*cmd.exe*"
```

## 2. CONTAINMENT

### Immediate Actions

#### 1. Block Outbound Traffic

```powershell
# Create firewall rule to block Meterpreter port
New-NetFirewallRule -DisplayName "Block Meterpreter" `
    -Direction Outbound `
    -LocalPort 4444 `
    -Protocol TCP `
    -Action Block

# Verify rule is created
Get-NetFirewallRule -DisplayName "Block Meterpreter"
```

#### 2. Isolate Affected System

```powershell
# Disable network adapters
Disable-NetAdapter -Name "Ethernet" -Confirm:$false

# Or through GUI
# Control Panel → Network and Sharing Center → Change adapter settings
# Right-click adapter → Disable
```

#### 3. Kill Malicious Process

```powershell
# Find malicious processes
Get-Process | Where-Object {$_.ProcessName -like "*pdf*" -or $_.ProcessName -like "*meterpreter*"}

# Kill specific process
Stop-Process -Name "resume.pdf" -Force

# Or use taskkill
taskkill /F /IM resume.pdf.exe
```

## 3. ERADICATION

### Remove Malware

#### 1. Delete Payload Files

```powershell
# Delete downloaded payloads
Remove-Item "C:\Users\LabUser\Downloads\*pdf.exe" -Force
Remove-Item "C:\Users\LabUser\Downloads\*.ps1" -Force
Remove-Item "C:\Users\LabUser\Downloads\*.vba" -Force
```

#### 2. Check for Persistence

```powershell
# Check scheduled tasks
Get-ScheduledTask | Where-Object {$_.TaskName -like "*pdf*" -or $_.TaskName -like "*meterpreter*"}

# Check services
Get-Service | Where-Object {$_.DisplayName -like "*Meterpreter*" -or $_.DisplayName -like "*Reverse*"}

# Check startup folder
Get-ChildItem -Path "C:\Users\LabUser\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

# Check registry for persistence
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
```

#### 3. Remove Persistence

```powershell
# Remove scheduled tasks
Unregister-ScheduledTask -TaskName "MaliciousTask" -Confirm:$false

# Stop and delete services
Stop-Service -Name "MeterpreterService" -Force
sc delete "MeterpreterService"

# Remove registry entries
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" `
    -Name "MaliciousApp"
```

## 4. RECOVERY

### Restore Security Controls

#### 1. Re-enable Windows Defender

```powershell
# Enable Real-time Protection
Set-MpPreference -DisableRealtimeMonitoring $false

# Enable Network Protection
Set-MpPreference -EnableNetworkProtection Enabled

# Enable Cloud Protection
Set-MpPreference -CloudBlockLevel 2

# Start Windows Defender Service
Start-Service -Name WinDefend
Set-Service -Name WinDefend -StartupType Automatic

# Start Security Center
Start-Service -Name wscsvc
Set-Service -Name wscsvc -StartupType Automatic
```

#### 2. Re-enable Windows Firewall

```powershell
# Enable firewall for all profiles
netsh advfirewall set allprofiles state on

# Verify firewall is on
netsh advfirewall show allprofiles
```

#### 3. Update Windows Defender

```powershell
# Update definitions
Update-MpSignature

# Run full system scan
Start-MpScan -ScanType FullScan
```

## 5. FORENSICS

### Collect Evidence

#### 1. Export Event Logs

```powershell
# Export Security logs
wevtutil epl Security C:\Logs\Security.evtx

# Export System logs
wevtutil epl System C:\Logs\System.evtx

# Export Sysmon logs
wevtutil epl Microsoft-Windows-Sysmon/Operational C:\Logs\Sysmon.evtx

# Export Application logs
wevtutil epl Application C:\Logs\Application.evtx

# Export PowerShell logs
wevtutil epl Microsoft-Windows-PowerShell/Operational C:\Logs\PowerShell.evtx
```

#### 2. Collect Process Information

```powershell
# Export running processes
Get-Process | Export-Csv -Path C:\Logs\Processes.csv -NoTypeInformation

# Export services
Get-Service | Export-Csv -Path C:\Logs\Services.csv -NoTypeInformation

# Export startup programs
Get-CimInstance -Class Win32_StartupCommand | Export-Csv -Path C:\Logs\Startup.csv -NoTypeInformation
```

#### 3. Collect Network Information

```powershell
# Export network connections
netstat -ano > C:\Logs\netstat.txt

# Export DNS cache
ipconfig /displaydns > C:\Logs\dns_cache.txt
```

## 6. PREVENTION

### Implement Security Controls

#### 1. ASR Rules

```powershell
# Enable Block Office applications from creating child processes
Add-MpPreference -AttackSurfaceReductionRules_Ids "D4F940AB-401B-4EFC-AADC-AD5F3C50688A" `
    -AttackSurfaceReductionRules_Actions Enabled

# Enable Block process injection
Add-MpPreference -AttackSurfaceReductionRules_Ids "75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84" `
    -AttackSurfaceReductionRules_Actions Enabled

# Enable Block executable content from email
Add-MpPreference -AttackSurfaceReductionRules_Ids "BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550" `
    -AttackSurfaceReductionRules_Actions Enabled
```

#### 2. Controlled Folder Access

```powershell
# Enable Controlled Folder Access
Set-MpPreference -EnableControlledFolderAccess Enabled

# Add protected folders
Add-MpPreference -ControlledFolderAccessProtectedFolders "C:\Users\LabUser\Documents"
Add-MpPreference -ControlledFolderAccessProtectedFolders "C:\Users\LabUser\Desktop"
Add-MpPreference -ControlledFolderAccessProtectedFolders "C:\Users\LabUser\Pictures"
```

#### 3. Application Control

```powershell
# Block PowerShell execution from unsanctioned sources
Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope LocalMachine

# Enable Windows AppLocker
# (Configure through Local Group Policy)
```

## 7. POST-INCIDENT

### Documentation

#### Create Incident Report

```markdown
# Incident Report: [Incident ID]

## Incident Details
- **Date**: [DATE]
- **Time**: [TIME]
- **Detected By**: [NAME]
- **Severity**: [Critical/High/Medium/Low]

## Timeline
- [HH:MM] - Detection by Splunk
- [HH:MM] - Initial investigation
- [HH:MM] - Containment initiated
- [HH:MM] - Eradication completed
- [HH:MM] - System recovered

## Root Cause
- [Describe root cause]

## Impact
- Systems Affected: [List]
- Data Affected: [List]
- Business Impact: [Describe]

## Lessons Learned
- [List improvements]

## Recommendations
- [List security improvements]
```

#### Submit to Security Team

- Include all evidence collected
- Document all actions taken
- Suggest improvements to security controls

---

## Appendix A: Quick Reference Commands

### Detection Commands

```powershell
# Find suspicious processes
Get-Process | Where-Object {$_.ProcessName -like "*pdf*"}

# Find network connections
netstat -ano | findstr "4444"

# Check event logs
Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4688} -MaxEvents 50
```

### Containment Commands

```powershell
# Block port
New-NetFirewallRule -DisplayName "BlockPort" -Direction Outbound -Protocol TCP -LocalPort 4444 -Action Block

# Kill process
Stop-Process -Name "resume.pdf" -Force

# Disable network
Disable-NetAdapter -Name "Ethernet" -Confirm:$false
```

### Eradication Commands

```powershell
# Delete files
Remove-Item "C:\Users\LabUser\Downloads\*.exe" -Force

# Remove scheduled tasks
Unregister-ScheduledTask -TaskName "MaliciousTask" -Confirm:$false

# Delete services
sc delete "MeterpreterService"
```

---

## Appendix B: Splunk Queries

### Process Creation Monitoring

```spl
index=endpoint EventCode=4688
| table _time, User, CommandLine, NewProcessName
| sort -_time
```

### Suspicious Command Detection

```spl
index=endpoint CommandLine="*whoami*" OR CommandLine="*net user*" OR CommandLine="*ipconfig*"
| stats count by _time, User, CommandLine
```

### Reverse Shell Detection

```spl
index=endpoint EventCode=3 DestinationPort=4444
| table _time, User, SourceAddress, DestinationAddress, DestinationPort
| sort -_time
```

### Malware File Detection

```spl
index=endpoint NewProcessName="*.pdf.exe"
| table _time, User, CommandLine, NewProcessName
| sort -_time
```

---

## Appendix C: Recovery Check Script

```powershell
# Complete Recovery Check Script
Write-Host "=== Recovery Verification ===" -ForegroundColor Yellow

# 1. Check Windows Defender
$defenderStatus = Get-MpPreference | Select-Object DisableRealtimeMonitoring, EnableNetworkProtection
Write-Host "Windows Defender Status:" -ForegroundColor Green
$defenderStatus

# 2. Check Firewall Status
$firewallStatus = netsh advfirewall show allprofiles | Select-String "State"
Write-Host "Firewall Status:" -ForegroundColor Green
$firewallStatus

# 3. Check Running Processes
$suspiciousProcesses = Get-Process | Where-Object {$_.ProcessName -like "*pdf*" -or $_.ProcessName -like "*meterpreter*"}
if ($suspiciousProcesses) {
    Write-Host "Suspicious Processes Found:" -ForegroundColor Red
    $suspiciousProcesses
} else {
    Write-Host "No Suspicious Processes Found" -ForegroundColor Green
}

# 4. Check Network Connections
$suspiciousPorts = netstat -ano | Select-String "4444"
if ($suspiciousPorts) {
    Write-Host "Suspicious Network Connections Found:" -ForegroundColor Red
    $suspiciousPorts
} else {
    Write-Host "No Suspicious Network Connections Found" -ForegroundColor Green
}

# 5. Check for Persistence
$startupFolder = Get-ChildItem "C:\Users\LabUser\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
if ($startupFolder) {
    Write-Host "Files in Startup Folder:" -ForegroundColor Yellow
    $startupFolder
}

Write-Host "=== Recovery Verification Complete ===" -ForegroundColor Green
```
