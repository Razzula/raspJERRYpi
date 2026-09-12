#!/usr/bin/env bash
set -euo pipefail

systemctl --user daemon-reload

for unit in containers/*/*.container; do
    service="$(basename "$unit" .container).service"
    systemctl --user enable --now "$service"
done
