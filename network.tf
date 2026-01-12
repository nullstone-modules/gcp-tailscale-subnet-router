data "ns_connection" "network" {
  name     = "network"
  contract = "network/gcp/vpc"
}

locals {
  vpc_name              = data.ns_connection.network.outputs.vpc_name
  private_cidrs         = data.ns_connection.network.outputs.private_cidrs
  private_service_cidrs = data.ns_connection.network.outputs.private_service_cidrs
  public_cidrs          = data.ns_connection.network.outputs.public_cidrs
  public_subnet_names   = data.ns_connection.network.outputs.public_subnet_names

  internal_domain_fqdn    = try(data.ns_connection.network.outputs.internal_domain_fqdn, "")
  internal_domain_zone_id = try(data.ns_connection.network.outputs.internal_domain_zone_id, "")
}
