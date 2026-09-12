# raspJERRYpi Homelab

Podman-based homelab configuration for Raspberry Pi.

| Service | Description |
|---|---|
| — | — |

## Hardware

Designed for:

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
    ├── <name>.env
    ├── <name>.env.example
    ├── <name>.container
    ├── <name>.build.sh
    └── <name>.config.sh
```

Each directory under `containers/` represents a service deployed to the homelab.

The files and directories are optional unless required by the service:

- `config/` — persistent application configuration
- `data/` — persistent application data
- `<name>.env` — local environment configuration and secrets
- `<name>.env.example` — example/template for the environment file
- `<name>.container` — Podman Quadlet definition
- `<name>.build.sh` — builds any custom container image required by the service
- `<name>.config.sh` — performs any service-specific initial configuration

### Configuration and build scripts

A service's `.build.sh` and `.config.sh` scripts are responsible for determining whether their work actually needs to be performed. They should use their own internal checks to avoid needless repetition when deployment or installation is run multiple times.

As a policy, all environment configuration must be represented by `<name>.env.example`. The real `<name>.env` file must not be committed to the repository and should be created by `<name>.configure.sh` from the corresponding example when required.

This allows service-specific setup, secrets, and image-building requirements to remain self-contained within each service directory.

## Installation

Containers are managed by Podman and systemd using Quadlet.

Make sure deviceis configured correctly, The specification can be compared against `./setup/*.sh`'s scripts.

## Deployment

The repository is intended to be cloned onto the Pi. Installation, deployment, and health checks are handled by the repository scripts.

Install the services:

```bash
./install.sh
```

Start the services:

```bash
./run.sh
```

Check service health:

```bash
./health.sh
```