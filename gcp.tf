data "google_client_config" "this" {}
data "google_compute_zones" "available" {}

locals {
  project_id      = data.google_client_config.this.project
  region          = data.google_client_config.this.region
  available_zones = data.google_compute_zones.available.names
}
