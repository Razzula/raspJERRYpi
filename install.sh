#!/usr/bin/env bash
set -euo pipefail

USER_QUADLET_DIR="$HOME/.config/containers/systemd"
SYSTEM_QUADLET_DIR="/etc/containers/systemd"

mkdir -p "$USER_QUADLET_DIR"

for container in containers/*; do
    name="$(basename "$container")"

    # configure
    if [[ -x "$container/$name.pre.sh" ]]; then
        echo "Configuring: $name"
        (
            cd "$container"
            "./$name.pre.sh"
        )
    fi

    # build
    if [[ -x "$container/$name.build.sh" ]]; then
        echo "Building: $name"
        (
            cd "$container"
            "./$name.build.sh"
        )
    fi

    # install
    if [[ -f "$container/.root" ]]; then
        target="$SYSTEM_QUADLET_DIR/$name"

        sudo mkdir -p "$SYSTEM_QUADLET_DIR"
        sudo ln -sfn "$(realpath "$container")" "$target"

        echo "Installed (rootful): $name"
    else
        target="$USER_QUADLET_DIR/$name"

        ln -sfn "$(realpath "$container")" "$target"

        echo "Installed (rootless): $name"
    fi

    # build
    if [[ -x "$container/$name.post.sh" ]]; then
        echo "Configuring: $name"
        (
            cd "$container"
            "./$name.post.sh"
        )
    fi
done

systemctl --user daemon-reload
sudo systemctl daemon-reload
