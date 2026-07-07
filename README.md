# 🏠 Cybersecurity Home Lab: Complete Security Operations & Penetration Testing Environment

[![VirtualBox](https://img.shields.io/badge/VirtualBox-5.2.44-blue)](https://www.virtualbox.org/)
[![pfSense](https://img.shields.io/badge/pfSense-2.6.0-orange)](https://www.pfsense.org/)
[![Splunk](https://img.shields.io/badge/Splunk-9.0.0-green)](https://www.splunk.com/)
[![Kali](https://img.shields.io/badge/Kali-2023.4-purple)](https://www.kali.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 📋 Executive Summary

This project implements a complete enterprise-grade cybersecurity home lab environment for security operations, penetration testing, and incident response training. The lab simulates a realistic corporate network with:

- **Network Segmentation**: Isolated LAN and DMZ zones via pfSense firewall
- **SIEM Implementation**: Splunk Enterprise for log aggregation and security monitoring
- **Endpoint Detection**: Sysmon for detailed Windows event logging
- **Offensive Security**: Kali Linux for penetration testing and attack simulation
- **Defensive Controls**: Windows Defender, ASR rules, and custom firewall policies
- **Incident Response**: Documented playbook for security incident handling

---

## 🏗️ Architecture Overview

```mermaid
graph TB
    subgraph "External Network"
        INTERNET[Internet]
    end
    
    subgraph "VirtualBox Host"
        subgraph "pfSense Firewall"
            WAN[WAN: NAT]
            LAN[LAN: 192.168.10.1/24]
            DMZ[DMZ: 192.168.20.1/24]
        end
        
        subgraph "LAN Zone - Trusted"
            WIN11[Windows 11 Pro<br/>192.168.10.10<br/>Splunk + Sysmon]
        end
        
        subgraph "DMZ Zone - Untrusted"
            KALI[Kali Linux<br/>192.168.20.10<br/>Metasploit + Nmap]
        end
    end
    
    INTERNET --> WAN
    WAN --> LAN
    WAN --> DMZ
    LAN --> WIN11
    DMZ --> KALI
    KALI -.->|Attack Traffic| WIN11
    WIN11 -->|Logs| SPLUNK[Splunk Enterprise]
