#!/usr/bin/env bash
set -euo pipefail

for unit in containers/*/*.container; do
    service="$(basename "$unit" .container).service"
    systemctl --user status "$service" --no-pager
done
