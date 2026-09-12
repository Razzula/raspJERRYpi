#!/usr/bin/env bash
set -euo pipefail

for unit in containers/*/*.container; do
    container="$(dirname "$unit")"
    name="$(basename "$unit" .container)"
    service="$name.service"

    if [[ -f "$container/.root" ]]; then
        sudo systemctl status "$service" --no-pager
    else
        systemctl --user status "$service" --no-pager
    fi
done
