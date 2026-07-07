# Splunk Enterprise Configuration Guide

## Installation

### Download
- URL: `https://www.splunk.com/en_us/download/splunk-enterprise.html`
- File: Windows `.msi` installer

### Install
1. Run the `.msi` installer
2. Accept defaults
3. Set admin credentials:
   - Username: `admin`
   - Password: `SecureLab2024!`
4. Click Finish

### Initial Setup
- Splunk opens at: `http://localhost:8000`
- Login: `admin` / `SecureLab2024!`
- Select "500 MB" for indexing volume

## Create Indexes

1. **Settings → Data → Indexes**
2. Click **New Index** for each:

| Index Name | Purpose |
|------------|---------|
| endpoint | Sysmon + Windows logs |
| security | Security Event Logs |
| network | Network connection logs |

## Configure Inputs

Edit: `C:\Program Files\Splunk\etc\system\local\inputs.conf`

See the `configs/splunk/inputs.conf` file in this repository for the full configuration.

## Restart Splunk

1. Open Services (`services.msc`)
2. Find "Splunk" service
3. Right-click → Restart
4. Wait 30 seconds

## Verify Data

1. Splunk Web → **Search & Reporting**
2. Search: `index=endpoint`
3. Set time range to "Last 5 minutes"
4. You should see events appearing

## Create Dashboard

1. **Dashboards → New Dashboard**
2. Name: `Security Operations Center`
3. Add panels for:
   - Process Creation (EventCode=4688)
   - Malware Detection (`resume.pdf.exe`)
   - Network Connections (EventCode=3)
   - Failed Logins (EventCode=4625)
