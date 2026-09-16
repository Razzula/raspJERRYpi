#!/usr/bin/env bash
set -euo pipefail

# handle config
mkdir -p config

if [[ ! -f homepage.env ]]; then
    cp homepage.env.example homepage.env

    read -rsp "WIREGUARD_PASSWORD:=" WIREGUARD_PASSWORD
    printf 'WIREGUARD_PASSWORD=%s\n' "$WIREGUARD_PASSWORD" >> homepage.env

    read -rsp "PIHOLE_PASSWORD:=" PIHOLE_PASSWORD
    printf 'PIHOLE_PASSWORD=%s\n' "$PIHOLE_PASSWORD" >> homepage.env

    chmod 600 homepage.env
fi

# EOF
echo
echo "Homepage configured."
