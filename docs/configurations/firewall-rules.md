# Windows Firewall Rules Configuration

## Outbound Block Rules

| Rule Name | Protocol | Port | Direction | Action | Purpose |
|-----------|----------|------|-----------|--------|---------|
| Block Meterpreter | TCP | 4444 | Outbound | Block | Prevent reverse shells |
| Block Meterpreter Alt | TCP | 5555 | Outbound | Block | Prevent alternative ports |

## How to Create Block Rules

1. Open **Windows Defender Firewall with Advanced Security**
2. Click **Outbound Rules** → **New Rule**
3. Select **Port** → Next
4. Protocol: **TCP**
5. Specific local ports: `4444,5555`
6. Action: **Block the connection** → Next
7. Apply to: **Domain, Private, Public** → Next
8. Name: `Block Meterpreter Reverse Shell`
9. Click Finish

## Inbound Allow Rules

| Rule Name | Protocol | Port | Action | Purpose |
|-----------|----------|------|--------|---------|
| Allow ICMP Echo Request | ICMPv4 | - | Allow | Ping testing |

## Quick PowerShell Commands

```powershell
# Block port 4444
New-NetFirewallRule -DisplayName "Block Meterpreter" `
    -Direction Outbound `
    -LocalPort 4444 `
    -Protocol TCP `
    -Action Block

# Enable firewall
netsh advfirewall set allprofiles state on

# Disable firewall (testing only)
netsh advfirewall set allprofiles state off
```
