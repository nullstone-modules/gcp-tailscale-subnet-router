locals {
  advertise_tags   = join(",", [for t in var.tags : "tag:${t}"])
  advertise_routes = join(",", concat(local.private_cidrs, local.public_cidrs))

  cloud_init = <<EOF
#!/bin/bash
set -euo pipefail

# Install Tailscale (Ubuntu/Debian)
curl -fsSL https://tailscale.com/install.sh | sh

# Ensure service is enabled and started
systemctl enable --now tailscaled

# Enable IPv4 and IPv6 forwarding
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sysctl -p /etc/sysctl.d/99-tailscale.conf

# Bring up Tailscale with subnet routing + tags + auth key
tailscale up \
  --advertise-routes=${local.advertise_routes} \
  --advertise-tags=${local.advertise_tags} \
  --auth-key=${var.auth_key}

EOF
}
