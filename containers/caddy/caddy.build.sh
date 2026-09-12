#!/usr/bin/env bash
set -euo pipefail

IMAGE="localhost/caddy-cloudflare:latest"
HASH_FILE=".caddy-dockerfile.sha256"

CURRENT_HASH="$(sha256sum Dockerfile | cut -d ' ' -f 1)"

if podman image exists "$IMAGE" && [[ -f "$HASH_FILE" ]] && [[ "$(cat "$HASH_FILE")" == "$CURRENT_HASH" ]]; then
    # already built, and matches current Dockerfile
    echo "Caddy image is up to date."
    exit 0
fi

echo "Building Caddy image..."
podman build -t "$IMAGE" .

printf '%s\n' "$CURRENT_HASH" > "$HASH_FILE"
