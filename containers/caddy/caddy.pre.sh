#!/usr/bin/env bash
set -euo pipefail

# handle config
mkdir -p data

if [[ ! -f caddy.env ]]; then
    cp caddy.env.example caddy.env

    echo "Enter the Cloudflare API token."
    read -rsp "CLOUDFLARE_TOKEN:=" CLOUDFLARE_TOKEN
    echo

    # test token
    RESPONSE="$(
        curl -sS \
            -H "Authorization: Bearer $CLOUDFLARE_TOKEN" \
            "https://api.cloudflare.com/client/v4/user/tokens/verify"
    )"

    if ! grep -q '"success":true' <<< "$RESPONSE"; then
        echo "Error: Cloudflare API token verification failed." >&2
        echo "$RESPONSE" >&2
        rm -f caddy.env
        exit 1
    fi

    printf 'CLOUDFLARE_TOKEN=%s\n' "$CLOUDFLARE_TOKEN" > caddy.env
    chmod 600 caddy.env
fi

# EOF
echo
echo "Caddy configured."
