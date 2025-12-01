locals {
  ssh_keys = join("\n", [for username, public_key in var.admin_ssh_public_keys : "${username}:${public_key}"])
}

resource "google_compute_instance" "this" {
  name         = local.resource_name
  machine_type = var.machine_type
  zone         = local.available_zones[0]
  tags         = ["tailscale-router"]
  labels       = local.labels

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2204-lts"
      size  = 10
      type  = "pd-balanced"
    }
  }

  network_interface {
    network    = local.vpc_name
    subnetwork = local.public_subnet_names[0]

    dynamic "access_config" {
      for_each = var.enable_ssh_access ? [1] : []

      content {
        nat_ip = local.public_ip
      }
    }
  }

  metadata_startup_script = local.cloud_init

  metadata = {
    ssh-keys = local.ssh_keys
  }
}
