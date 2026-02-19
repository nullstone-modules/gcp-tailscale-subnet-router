variable "enable_ssh_access" {
  type        = bool
  default     = false
  description = <<EOF
Enable SSH access to the subnet router.
When enabled, a public IP address is created and attached to the subnet router.
When disabled, there is no public access to the subnet router.

This should be disabled once the subnet router is configured.
EOF
}

variable "admin_ssh_public_keys" {
  type        = map(string)
  description = <<EOF
A map of SSH public keys to add to the subnet router's authorized_keys file.
This allows an admin to access the subnet router over SSH.
EOF
}

variable "machine_type" {
  type        = string
  default     = "e2-small"
  description = <<EOF
Machine Type that dictates CPU, Memory, network bandwidth, and file storage type and bandwidth.
EOF
}

variable "auth_key" {
  type        = string
  sensitive   = true
  description = <<EOF
Use an auth key to automatically register the subnet router with Tailscale.
Visit [Keys](https://login.tailscale.com/admin/settings/keys) to create an auth key.
For security reasons, set the auth key to expire in 1 day and *not* be reusable.
If this subnet router is recreated, a new auth key is necessary to register with Tailscale.
EOF
}

variable "resource_alerts" {
  type = object({
    enabled = bool
    email   = string
    cpu     = number
  })
  default = {
    enabled = false
    email   = ""
    cpu     = 90
  }
  description = <<EOF
Configure CPU utilization alerting for the subnet router instance.
When enabled, a GCP monitoring alert policy is created that notifies the given email address
when CPU utilization exceeds the configured threshold (0-100).
EOF

  validation {
    condition     = !var.resource_alerts.enabled || var.resource_alerts.email != ""
    error_message = "email must be specified if alerts are enabled"
  }
}

variable "tags" {
  type    = list(string)
  default = []

  description = <<EOF
A list of tags that will be used to register this node with tailscale.
This module will add `tag:` prefix so don't add it.

Before adding a tag here, the tag must be added in the tailscale admin.

See https://tailscale.com/kb/1068/tags for more information on tailscale tags.
EOF
}
