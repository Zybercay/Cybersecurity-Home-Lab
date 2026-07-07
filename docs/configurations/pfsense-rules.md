# pfSense Firewall Rules Configuration

## DMZ Rules (Order Matters!)

| Order | Action | Protocol | Source | Destination | Port | Description |
|-------|--------|----------|--------|-------------|------|-------------|
| 1 | Pass | ICMP | DMZ Net | Any | - | Allow ICMP from DMZ |
| 2 | Pass | Any | DMZ Net | LAN Net | Any | Allow Kali to Windows |
| 3 | Pass | Any | DMZ Net | Any | Any | Allow DMZ to Internet |
| 4 | Block | TCP | DMZ Net | This Firewall | HTTPS (443) | Block pfSense management |
| 5 | Block | Any | Any | Any | Any | Default Deny |

## LAN Rules

| Order | Action | Protocol | Source | Destination | Port | Description |
|-------|--------|----------|--------|-------------|------|-------------|
| 1 | Pass | Any | LAN Net | Any | Any | LAN to Internet |
| 2 | Block | Any | Any | Any | Any | Default Deny |

## NAT Outbound Rules

| Interface | Source | Destination | Description |
|-----------|--------|-------------|-------------|
| WAN | DMZ Net | Any | DMZ to Internet |

## How to Configure in pfSense WebGUI

1. Access pfSense: `https://192.168.10.1` (admin/pfsense)
2. **Firewall → Rules → DMZ**
3. Click **Add** to create each rule
4. Set Action, Protocol, Source, Destination
5. Click **Save → Apply Changes**
6. Verify rule order matches the table above
