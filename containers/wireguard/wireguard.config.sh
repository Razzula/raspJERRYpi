#!/usr/bin/env bash
set -euo pipefail

# handle config
mkdir -p config

if [[ ! -f wireguard.env ]]; then
    cp wireguard.env.example wireguard.env

    echo "Enter thepublic WireGuard host URL/IP."
    read -rp "WG_HOST:=" WG_HOST

    if [[ -z "$WG_HOST" ]]; then
        echo "ERROR: WG_HOST cannot be empty." >&2
        exit 1
    fi

    printf 'WG_HOST=%s\n' "$WG_HOST" >> wireguard.env

    chmod 600 wireguard.env
fi

# EOF
echo
echo "WireGuard configured."
