#!/bin/sh

# pfSense Firewall Rules Helper Script
# Run this directly on the pfSense VM console (Option 8: Shell)
# Purpose: View, enable, disable, and apply basic firewall rules

echo "=========================================="
echo "  pfSense Firewall Helper Script"
echo "  For troubleshooting and quick config"
echo "=========================================="
echo ""

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: This script must be run as root."
    echo "Run: sudo sh /path/to/firewall-rules.sh"
    exit 1
fi

# Show current firewall status
echo "[1] CURRENT FIREWALL STATUS:"
echo "---------------------------"
pfctl -s info | grep "Status:"
echo ""

# Show current rules (top 20 for readability)
echo "[2] CURRENT ACTIVE RULES (Top 20):"
echo "----------------------------------"
pfctl -s rules | head -n 20
echo ""

# Show interface IP addresses
echo "[3] INTERFACE IP ADDRESSES:"
echo "---------------------------"
ifconfig | grep -E "^(em|vtnet|igb|hn)" -A 1 | grep -v "groups:" | grep -v "status:"
echo ""

# Show NAT rules
echo "[4] CURRENT NAT RULES:"
echo "----------------------"
pfctl -s nat | head -n 10
echo ""

# Menu for actions
echo "=========================================="
echo "  ACTIONS:"
echo "  1) Temporarily DISABLE firewall (pfctl -d)"
echo "  2) Re-ENABLE firewall (pfctl -e)"
echo "  3) Flush ALL firewall rules (Emergency reset)"
echo "  4) Show full rule list"
echo "  5) Show DMZ rules only"
echo "  6) Exit"
echo "=========================================="
echo -n "Enter your choice (1-6): "
read choice

case $choice in
    1)
        echo ""
        echo "Disabling firewall temporarily..."
        pfctl -d
        echo "Firewall DISABLED. To re-enable, run: pfctl -e"
        echo "WARNING: This is temporary. A reboot will re-enable it."
        ;;
    2)
        echo ""
        echo "Re-enabling firewall..."
        pfctl -e
        echo "Firewall ENABLED."
        ;;
    3)
        echo ""
        echo "FLUSHING ALL RULES!"
        echo "WARNING: This will remove all firewall rules until reboot."
        echo -n "Are you sure? Type 'yes' to confirm: "
        read confirm
        if [ "$confirm" = "yes" ]; then
            pfctl -F all
            echo "All rules flushed. System is now OPEN."
        else
            echo "Flush cancelled."
        fi
        ;;
    4)
        echo ""
        echo "FULL RULE LIST:"
        pfctl -s rules
        ;;
    5)
        echo ""
        echo "DMZ RULES (OPT1 - em2):"
        echo "Filtering for DMZ rules..."
        pfctl -s rules | grep -i "em2" | head -n 20
        ;;
    6)
        echo "Exiting."
        exit 0
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo ""
echo "=========================================="
echo "  SCRIPT COMPLETE"
echo "=========================================="
