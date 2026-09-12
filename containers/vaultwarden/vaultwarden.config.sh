#!/usr/bin/env bash
set -euo pipefail

# handle data
mkdir -p data

# handle config
if [[ ! -f vaultwarden.env ]]; then
    cp vaultwarden.env.example vaultwarden.env

    echo "Generate the Vaultwarden admin token."
    echo "Enter the admin password when prompted:"
    echo

    TEMP_FILE="$(mktemp)"
    trap 'rm -f "$TEMP_FILE"' EXIT

    podman run --rm -it \
        docker.io/vaultwarden/server:latest \
        /vaultwarden hash | tee "$TEMP_FILE"

    ADMIN_TOKEN="$(
        grep '^ADMIN_TOKEN=' "$TEMP_FILE" |
        sed "s/^ADMIN_TOKEN=//"
    )"

    if [[ -z "$ADMIN_TOKEN" ]]; then
        echo "ERROR: Failed to generate Vaultwarden admin token." >&2
        exit 1
    fi

    printf '\nADMIN_TOKEN=%s\n' "$ADMIN_TOKEN" >> vaultwarden.env

    chmod 600 vaultwarden.env
fi

# EOF
echo
echo "Vaultwarden configured."
