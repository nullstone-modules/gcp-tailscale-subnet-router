resource "google_compute_address" "this" {
  name   = local.resource_name
  region = local.region
  labels = local.labels

  count = var.enable_ssh_access ? 1 : 0
}

locals {
  public_ip = var.enable_ssh_access ? google_compute_address.this.address : ""
}
