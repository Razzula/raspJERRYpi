#!/usr/bin/env bash
set -euo pipefail

for unit in containers/*/*.container; do
    container="$(dirname "$unit")"
    name="$(basename "$unit" .container)"
    service="$name.service"

    if [[ -f "$container/.root" ]]; then
        echo -n "Starting $service (rootful)... "
        sudo systemctl reset-failed "$service" 2>/dev/null || true
        sudo systemctl restart "$service"
    else
        echo -n "Starting $service... "
        systemctl --user reset-failed "$service" 2>/dev/null || true
        systemctl --user restart "$service"
    fi

    echo "OK"
done
