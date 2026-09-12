#!/usr/bin/env bash
set -euo pipefail

EXPECTED_INTERFACE="eth0"
EXPECTED_GATEWAY="192.168.0.1"
STATIC_IP="192.168.0.2/24"

echo "Checking network interface..."

if ! ip link show "$EXPECTED_INTERFACE" >/dev/null 2>&1; then
    echo "ERROR: Interface '$EXPECTED_INTERFACE' does not exist."
    echo
    echo "Available interfaces:"
    ip -br link
    exit 1
fi

CURRENT_INTERFACE=$(ip route show default | awk '{print $5; exit}')
CURRENT_GATEWAY=$(ip route show default | awk '{print $3; exit}')

echo "Detected default route:"
echo "  Interface: ${CURRENT_INTERFACE:-none}"
echo "  Gateway:   ${CURRENT_GATEWAY:-none}"
echo

if [[ "$CURRENT_INTERFACE" != "$EXPECTED_INTERFACE" ]]; then
    echo "ERROR: The default route is not using '$EXPECTED_INTERFACE'."
    exit 1
fi

if [[ "$CURRENT_GATEWAY" != "$EXPECTED_GATEWAY" ]]; then
    echo "ERROR: The default gateway is not '$EXPECTED_GATEWAY'."
    exit 1
fi

echo "Network configuration looks correct."
echo
echo "This script will configure:"
echo "  Interface: $EXPECTED_INTERFACE"
echo "  Address:   $STATIC_IP"
echo "  Gateway:   $EXPECTED_GATEWAY"
echo "  DNS:       $EXPECTED_GATEWAY, 1.1.1.1"
echo

read -rp "Continue with this static IP configuration? [y/N] " CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo
echo "Configuring Netplan..."

sudo netplan set ethernets."$EXPECTED_INTERFACE".dhcp4=false
sudo netplan set "ethernets.$EXPECTED_INTERFACE.addresses=[$STATIC_IP]"
sudo netplan set "ethernets.$EXPECTED_INTERFACE.routes=[{to: default, via: $EXPECTED_GATEWAY}]"
sudo netplan set "ethernets.$EXPECTED_INTERFACE.nameservers.addresses=[$EXPECTED_GATEWAY,1.1.1.1]"

echo
echo "Resulting configuration:"
sudo netplan get

echo
echo "Netplan will now test the configuration."
echo "(If connectivity is lost, it will automatically roll back.)"
echo

sudo netplan try
