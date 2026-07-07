# Network Architecture Diagram


## Complete Network Topology

```mermaid
flowchart TB
    subgraph Internet["🌐 Internet"]
        ISP[ISP Gateway]
    end

    subgraph Host["💻 Host Machine (VirtualBox)"]
        subgraph pfSense["🛡️ pfSense Firewall"]
            WAN[WAN Interface<br/>DHCP from NAT]
            LAN_IF[LAN Interface<br/>192.168.10.1/24]
            DMZ_IF[DMZ Interface<br/>192.168.20.1/24]
            
            WAN --> LAN_IF
            WAN --> DMZ_IF
        end
        
        subgraph LAN_Segment["🔒 LAN Segment (Trusted)"]
            WIN11[🖥️ Windows 11 Pro<br/>192.168.10.10<br/><br/>- Splunk Enterprise<br/>- Sysmon<br/>- Target Machine]
        end
        
        subgraph DMZ_Segment["⚠️ DMZ Segment (Untrusted)"]
            KALI[🐉 Kali Linux<br/>192.168.20.10<br/><br/>- Metasploit<br/>- Nmap<br/>- Attack Tools]
        end
    end

    ISP -->|NAT| WAN
    LAN_IF -->|Internal Network| WIN11
    DMZ_IF -->|Internal Network| KALI
    
    KALI -->|Attack Traffic| WIN11
    WIN11 -->|Logs| SPLUNK[Splunk Enterprise<br/>Localhost:8000]
    
    classDef firewall fill:#ff6b6b,stroke:#c92a2a,color:white
    classDef target fill:#4dabf7,stroke:#1971c2,color:white
    classDef attacker fill:#ffd43b,stroke:#f59f00,color:black
    
    class pfSense,WAN,LAN_IF,DMZ_IF firewall
    class WIN11 target
    class KALI attacker
```

## Security Zones

| Zone | Network | Purpose | Access Control |
|------|---------|---------|----------------|
| **Internet (WAN)** | DHCP (NAT) | External Access | Controlled by pfSense |
| **LAN** | 192.168.10.0/24 | Trusted Network | Full access to internet |
| **DMZ** | 192.168.20.0/24 | Untrusted Network | Restricted access to LAN |

## Firewall Rules Matrix

| Source | Destination | Protocol | Port | Action | Purpose |
|--------|------------|----------|------|--------|---------|
| DMZ | Any | ICMP | - | Allow | ICMP Testing |
| DMZ | LAN | Any | Any | Allow | Kali → Windows |
| DMZ | Any | Any | Any | Allow | Internet Access |
| DMZ | Firewall | TCP | 443 | Block | Block Management |
| LAN | Any | Any | Any | Allow | Internet Access |
| Any | Any | Any | Any | Block | Default Deny |
