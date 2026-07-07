# Enable Windows Security Features
# Run as Administrator

Write-Host "=== Enabling Windows Security Features ===" -ForegroundColor Yellow

# 1. Enable Real-time Protection
Write-Host "Enabling Real-time Protection..." -ForegroundColor Green
Set-MpPreference -DisableRealtimeMonitoring $false

# 2. Enable Network Protection
Write-Host "Enabling Network Protection..." -ForegroundColor Green
Set-MpPreference -EnableNetworkProtection Enabled

# 3. Enable Cloud Protection
Write-Host "Enabling Cloud Protection..." -ForegroundColor Green
Set-MpPreference -CloudBlockLevel 2

# 4. Enable Behavior Monitoring
Write-Host "Enabling Behavior Monitoring..." -ForegroundColor Green
Set-MpPreference -EnableBehaviorMonitoring $true

# 5. Enable Script Scanning
Write-Host "Enabling Script Scanning..." -ForegroundColor Green
Set-MpPreference -DisableScriptScanning $false

# 6. Enable Block at First Sight
Write-Host "Enabling Block at First Sight..." -ForegroundColor Green
Set-MpPreference -EnableBlockAtFirstSeen $true

# 7. Enable PUA Protection
Write-Host "Enabling PUA Protection..." -ForegroundColor Green
Set-MpPreference -PUAProtection Enabled

# 8. Enable SmartScreen
Write-Host "Enabling SmartScreen..." -ForegroundColor Green
Set-MpPreference -EnableSmartScreen $true

# 9. Start Windows Defender Service
Write-Host "Starting Windows Defender Service..." -ForegroundColor Green
Start-Service -Name WinDefend -ErrorAction SilentlyContinue
Set-Service -Name WinDefend -StartupType Automatic

# 10. Start Security Center Service
Write-Host "Starting Security Center Service..." -ForegroundColor Green
Start-Service -Name wscsvc -ErrorAction SilentlyContinue
Set-Service -Name wscsvc -StartupType Automatic

# 11. Enable Windows Firewall
Write-Host "Enabling Windows Firewall..." -ForegroundColor Green
netsh advfirewall set allprofiles state on

Write-Host "=== Verification ===" -ForegroundColor Yellow
Get-MpPreference | Select-Object DisableRealtimeMonitoring, EnableNetworkProtection, CloudBlockLevel
netsh advfirewall show allprofiles | Select-String "State"

Write-Host "`n=== Security Features Enabled Successfully ===" -ForegroundColor Green
