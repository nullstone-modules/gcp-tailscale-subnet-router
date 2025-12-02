# Allow Tailscale control port (UDP 41641) and HTTPS (TCP 443)
resource "google_compute_firewall" "tailscale" {
  name               = "${local.resource_name}-tailscale"
  network            = local.vpc_name
  description        = "Allow subnet router to connect to Tailscale network"
  direction          = "EGRESS"
  target_tags        = ["tailscale-router"]
  destination_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "udp"
    ports    = ["41641"]
  }

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}

# Allow SSH (TCP 22)
resource "google_compute_firewall" "ssh" {
  name          = "${local.resource_name}-ssh"
  network       = local.vpc_name
  description   = "Allow ssh access to subnet router"
  direction     = "INGRESS"
  target_tags   = ["tailscale-router"]
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  count = var.enable_ssh_access ? 1 : 0
}
