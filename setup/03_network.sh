# configure podman
podman network create homelab

# allow 80, 443, etc. to run rootless
echo 'net.ipv4.ip_unprivileged_port_start=53' | sudo tee /etc/sysctl.d/99-rootless-ports.conf
sudo sysctl --system

# prevent runtime depending on session
sudo loginctl enable-linger razzula
