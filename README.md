# gcp-tailscale-subnet-router

Creates a Tailscale subnet router to access a GCP network

## Forward private GCP DNS zones

The default GCP network creates a private DNS zone to provide internal DNS resolution inside the VPC.
This module creates a VM with dnsmasq configured to forward DNS queries to the private GCP zone through this subnet router.

Once launched, you will need to manually add Split DNS in your Tailscale admin console to forward DNS queries.
- Go to https://login.tailscale.com/admin/dns
- Click "Add nameserver" > Custom...
- Enter the internal IP of the subnet router. (Look in the terraform outputs)
- Enable "Restrict to domain" > Enter the private GCP subdomain in the "Domain" box.
- Click "Save"
