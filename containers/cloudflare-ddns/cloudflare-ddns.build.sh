#!/usr/bin/env bash
set -euo pipefail

IMAGE="localhost/cfddns:latest"
HASH_FILE=".cfddns-build.sha256"

CURRENT_HASH="$(
    sha256sum Dockerfile data/update.sh |
    sha256sum |
    cut -d ' ' -f 1
)"

if podman image exists "$IMAGE" && [[ -f "$HASH_FILE" ]] && [[ "$(cat "$HASH_FILE")" == "$CURRENT_HASH" ]]; then
    # already built, and matches current Dockerfile
    echo "cloudflare-ddns image is up to date."
    exit 0
fi

echo "Building cfddns image..."
podman build -t "$IMAGE" .

printf '%s\n' "$CURRENT_HASH" > "$HASH_FILE"
