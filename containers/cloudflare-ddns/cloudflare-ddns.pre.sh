#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f cloudflare-ddns.env ]]; then
    cp cloudflare-ddns.env.example cloudflare-ddns.env

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
        rm -f cloudflare-ddns.env
        exit 1
    fi

    read -rp "DNS record name: " CF_RECORD_NAME

    printf 'CLOUDFLARE_TOKEN=%s\n' "$CLOUDFLARE_TOKEN" >> cloudflare-ddns.env
    printf 'CF_RECORD_NAME=%s\n' "$CF_RECORD_NAME" >> cloudflare-ddns.env

    chmod 600 cloudflare-ddns.env
fi

# EOF
echo
echo "Cloudflare DDNS configured."
