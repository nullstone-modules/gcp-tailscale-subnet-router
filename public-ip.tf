// Normally, we would only create a public ip for the instance if SSH was enabled
// However, the subnet router doesn't establish a connection to Tailscale without it
// As a result, we're going to always create this public ip
// Ideally, it wouldn't have a public ip, but as long as there isn't a firewall rule allowing it, we're safe enough
resource "google_compute_address" "this" {
  name   = local.resource_name
  region = local.region
  labels = local.labels
}

locals {
  public_ip = var.enable_ssh_access ? google_compute_address.this.address : ""
}
