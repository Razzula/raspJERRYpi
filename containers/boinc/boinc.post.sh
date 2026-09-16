#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f lhc.env ]]; then
    if ! podman container exists boinc; then
        systemctl --user daemon-reload
        systemctl --user start boinc.service
    fi
    if ! podman container exists boinc; then
        echo "ERROR: BOINC failed to start." >&2
        systemctl --user status boinc.service --no-pager -l
        exit 1
    fi

    # LHC@home credentials
    echo "Enter the LHC@home account key."
    read -rsp "LHC_ACCOUNT_KEY:=" LHC_ACCOUNT_KEY
    echo

    if [[ -z "$LHC_ACCOUNT_KEY" ]]; then
        echo "ERROR: LHC_ACCOUNT_KEY cannot be empty." >&2
        exit 1
    fi

    cp lhc.env.example lhc.env
    printf 'LHC_ACCOUNT_KEY=%s\n' "$LHC_ACCOUNT_KEY" >> lhc.env

    chmod 600 lhc.env

    # attach to LHC@home
    source lhc.env

    echo "Attaching BOINC to LHC@home..."

    podman exec boinc \
        boinccmd \
        --project_attach \
        https://lhcathome.cern.ch/lhcathome/ \
        "$LHC_ACCOUNT_KEY"
    fi

echo
echo "LHC@home configured."
