#!/usr/bin/env bash
set -euo pipefail

# handle config
mkdir -p config

if [[ ! -f wireguard.env ]]; then
    cp wireguard.env.example wireguard.env
    chmod 600 wireguard.env
fi

# EOF
echo
echo "WireGuard configured."
