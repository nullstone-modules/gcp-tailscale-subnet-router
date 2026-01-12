locals {
  # Configure dnsmasq to forward private GCP zones to Tailnet if local.internal_domain_fqdn is not empty

  dnsmasq_tailscale_split_config = <<EOF
# Only listen on Tailscale
interface=tailscale0
bind-interfaces

# do NOT listen on loopback at all
except-interface=lo

# Forward Cloud DNS private zone
server=/${trimsuffix(local.internal_domain_fqdn, ".")}/169.254.169.254

cache-size=1000
EOF

  dnsmasq_init = local.internal_domain_fqdn == "" ? "" : <<EOF
# Install and start dnsmasq
sudo apt-get install -yq dnsmasq

# Add dnsmasq configuration to provide split DNS to private GCP zones
sudo tee /etc/dnsmasq.d/tailscale-split.conf >/dev/null <<-EOT
${local.dnsmasq_tailscale_split_config}
EOT

# Restart dnsmasq to apply changes
sudo systemctl restart dnsmasq
sudo systemctl enable dnsmasq

EOF
}

locals {
  advertise_tags   = join(",", [for t in var.tags : "tag:${t}"])
  advertise_routes = join(",", concat(local.private_cidrs, local.public_cidrs, local.private_service_cidrs))

  cloud_init = <<EOF
#!/usr/env/bin bash
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

${local.dnsmasq_init}
EOF
}
