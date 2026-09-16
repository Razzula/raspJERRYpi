#!/usr/bin/env bash
set -euo pipefail

mkdir -p data

if [[ ! -f boinc.env ]]; then
    cp boinc.env.example boinc.env

    echo "Enter the BOINC password."
    read -rsp "PASSWORD:=" PASSWORD
    echo

    if [[ -z "$PASSWORD" ]]; then
        echo "ERROR: PASSWORD cannot be empty." >&2
        exit 1
    fi

    printf 'PASSWORD=%s\n' "$PASSWORD" >> boinc.env

    chmod 600 boinc.env
fi

echo
echo "BOINC configured."
