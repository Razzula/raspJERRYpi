# raspJERRYpi Homelab

Podman-based homelab configuration for Raspberry Pi.

## Hardware
Designed for
- Raspberry Pi 5
- Ubuntu Server LTS 26.04
- Podman
- Quadlet

## Structure

```
containers/
└── <name>/
    ├── config/
    ├── data/
    └── <name>.container
```

Each directory under `containers/` represents a service deployed to the Raspberry Pi.

- `config/` — persistent application configuration
- `data/` — persistent application data
- `<name>.container` — Podman Quadlet definition

## Installation

Containers are managed by Podman and systemd using Quadlet.

```bash
sudo apt update
sudo apt upgrade
```

```bash
sudo apt install podman
```

```bash
# verify installation
podman --version
systemctl --version
```

## Deployment

The repository is intended to be cloned onto the Raspberry Pi, with each service installed from its corresponding Quadlet definition.

## Services

| Service | Description |
|---|---|
| — | — |
