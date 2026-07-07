# Windows Defender Disable Script
# Run as Administrator

Write-Host "=== Disabling Windows Defender Features ===" -ForegroundColor Yellow

# 1. Disable Real-time Protection
Write-Host "Disabling Real-time Protection..." -ForegroundColor Green
Set-MpPreference -DisableRealtimeMonitoring $true

# 2. Disable Network Protection
Write-Host "Disabling Network Protection..." -ForegroundColor Green
Set-MpPreference -EnableNetworkProtection Disabled

# 3. Disable Cloud Protection
Write-Host "Disabling Cloud Protection..." -ForegroundColor Green
Set-MpPreference -CloudBlockLevel 0
Set-MpPreference -CloudTimeout 0

# 4. Disable Behavior Monitoring
Write-Host "Disabling Behavior Monitoring..." -ForegroundColor Green
Set-MpPreference -EnableBehaviorMonitoring $false

# 5. Disable Script Scanning
Write-Host "Disabling Script Scanning..." -ForegroundColor Green
Set-MpPreference -DisableScriptScanning $true

# 6. Disable Block at First Sight
Write-Host "Disabling Block at First Sight..." -ForegroundColor Green
Set-MpPreference -EnableBlockAtFirstSeen $false

# 7. Disable PUA Protection
Write-Host "Disabling PUA Protection..." -ForegroundColor Green
Set-MpPreference -PUAProtection Disabled

# 8. Disable SmartScreen
Write-Host "Disabling SmartScreen..." -ForegroundColor Green
Set-MpPreference -EnableSmartScreen $false

# 9. Add Exclusions
Write-Host "Adding Exclusions..." -ForegroundColor Green
Add-MpPreference -ExclusionPath "C:\Users\LabUser\Downloads"
Add-MpPreference -ExclusionExtension ".exe"
Add-MpPreference -ExclusionExtension ".ps1"
Add-MpPreference -ExclusionExtension ".bat"
Add-MpPreference -ExclusionExtension ".cmd"

# 10. Stop Windows Defender Service
Write-Host "Stopping Windows Defender Service..." -ForegroundColor Green
Stop-Service -Name WinDefend -Force

# 11. Disable Windows Defender Service
Write-Host "Disabling Windows Defender Service..." -ForegroundColor Green
Set-Service -Name WinDefend -StartupType Disabled

# 12. Disable Security Center Service
Write-Host "Disabling Security Center Service..." -ForegroundColor Green
Stop-Service -Name wscsvc -Force
Set-Service -Name wscsvc -StartupType Disabled

# 13. Disable Windows Firewall
Write-Host "Disabling Windows Firewall..." -ForegroundColor Green
netsh advfirewall set allprofiles state off

Write-Host "=== Verification ===" -ForegroundColor Yellow
Get-MpPreference | Select-Object DisableRealtimeMonitoring, EnableNetworkProtection, 
    CloudBlockLevel, DisableScriptScanning

netsh advfirewall show allprofiles | Select-String "State"

Write-Host "`n=== Windows Defender Disabled Successfully ===" -ForegroundColor Green
