#!/usr/bin/env bash
set -euo pipefail

# handle data
mkdir -p data

# handle config
if [[ ! -f "$SCRIPT_DIR/wireguard.env" ]]; then
    cp vaultwarden.env.example vaultwarden.env

    # use Vaultwarden to generate password hash
    echo "Generate the Vaultwarden admin token."
    echo "Enter the admin password when prompted:"
    echo

    ADMIN_TOKEN="$(
        podman run --rm -it \
            docker.io/vaultwarden/server:latest \
            /vaultwarden hash
    )"

    printf '\nADMIN_TOKEN=%s\n' "$ADMIN_TOKEN" >> vaultwarden.env

    chmod 600 vaultwarden.env
fi

# EOF
echo
echo "Vaultwarden configured."
