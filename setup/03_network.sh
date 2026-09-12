# configure podman
podman network create homelab

# allow 80, 443, etc. to run rootless
echo 'net.ipv4.ip_unprivileged_port_start=80' | sudo tee /etc/sysctl.d/99-rootless-ports.conf
sudo sysctl --system
