#!/usr/bin/env bash
set -euo pipefail

# handle config
mkdir -p config

if [[ ! -f pihole.env ]]; then
    # Pi-hole requires host port 53.
    # Disable systemd-resolved's local DNS stub listener.
    sudo mkdir -p /etc/systemd/resolved.conf.d

    sudo tee /etc/systemd/resolved.conf.d/pihole.conf >/dev/null <<'EOF'
[Resolve]
DNSStubListener=no
EOF

    sudo systemctl restart systemd-resolved

    # handle password
    touch pihole.env

    read -rsp "Set password: " PASSWORD
    echo

    if [[ -z "$PASSWORD" ]]; then
        echo "ERROR: Password cannot be empty." >&2
        exit 1
    fi

    printf '\nPIHOLE_WEB_PASSWORD=%s\n' "$PASSWORD" >> pihole.env

    chmod 600 pihole.env
fi

# EOF
echo
echo "Pi-Hole configured."

