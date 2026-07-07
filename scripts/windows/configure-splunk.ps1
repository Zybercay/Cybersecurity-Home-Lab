# Splunk Configuration Script
# Run as Administrator

Write-Host "=== Configuring Splunk Inputs ===" -ForegroundColor Yellow

# Define paths
$splunkLocal = "C:\Program Files\Splunk\etc\system\local"
$inputsConf = "$splunkLocal\inputs.conf"

# Create directory if missing
if (!(Test-Path $splunkLocal)) {
    New-Item -Path $splunkLocal -ItemType Directory -Force
}

# Backup existing config
if (Test-Path $inputsConf) {
    Copy-Item $inputsConf "$inputsConf.bak"
    Write-Host "Backup created: inputs.conf.bak" -ForegroundColor Green
}

# Write new configuration
@"
### Splunk Input Configuration
### Created: $(Get-Date)

[WinEventLog://Application]
index = endpoint
sourcetype = WinEventLog
disabled = 0

[WinEventLog://System]
index = endpoint
sourcetype = WinEventLog
disabled = 0

[WinEventLog://Security]
index = security
sourcetype = WinEventLog
disabled = 0

[WinEventLog://Microsoft-Windows-Sysmon/Operational]
index = endpoint
sourcetype = XmlWinEventLog
disabled = 0

[WinEventLog://Windows PowerShell]
index = endpoint
sourcetype = WinEventLog
disabled = 0
"@ | Out-File -FilePath $inputsConf -Encoding utf8

Write-Host "Configuration written to: $inputsConf" -ForegroundColor Green

# Restart Splunk
Write-Host "Restarting Splunk service..." -ForegroundColor Yellow
Restart-Service -Name "Splunk*" -ErrorAction SilentlyContinue

Write-Host "=== Splunk Configuration Complete ===" -ForegroundColor Green
Write-Host "Access Splunk at: http://localhost:8000" -ForegroundColor Cyan
Write-Host "Credentials: admin / SecureLab2024!" -ForegroundColor Cyan
