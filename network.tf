data "ns_connection" "network" {
  name     = "network"
  contract = "network/gcp/vpc"
}

locals {
  vpc_name            = data.ns_connection.network.outputs.vpc_name
  private_cidrs       = data.ns_connection.network.outputs.private_cidrs
  public_cidrs        = data.ns_connection.network.outputs.public_cidrs
  public_subnet_names = data.ns_connection.network.outputs.public_subnet_names
}
