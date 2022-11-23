resource "oci_core_virtual_network" "FoggyKitchenVCN" {
  cidr_block = var.VCN-CIDR
  dns_label = "FoggyKitchenVCN"
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  display_name = "FoggyKitchenVCN"
}

resource "oci_core_internet_gateway" "FoggyKitchenInternetGateway" {
    compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
    display_name = "FoggyKitchenInternetGateway"
    vcn_id = oci_core_virtual_network.FoggyKitchenVCN.id
}

resource "oci_core_nat_gateway" "FoggyKitchenNATGateway" {
    compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
    display_name = "FoggyKitchenNATGateway"
    vcn_id = oci_core_virtual_network.FoggyKitchenVCN.id
}

resource "oci_core_dhcp_options" "FoggyKitchenDhcpOptions1" {
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  vcn_id = oci_core_virtual_network.FoggyKitchenVCN.id
  display_name = "FoggyKitchenDHCPOptions1"

  // required
  options {
    type = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

  // optional
  options {
    type = "SearchDomain"
    search_domain_names = [ "foggykitchen.com" ]
  }
}

resource "oci_core_route_table" "FoggyKitchenRouteTableViaIGW" {
    compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
    vcn_id = oci_core_virtual_network.FoggyKitchenVCN.id
    display_name = "FoggyKitchenRouteTableViaIGW"
    route_rules {
        destination = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
        network_entity_id = oci_core_internet_gateway.FoggyKitchenInternetGateway.id
    }
}

resource "oci_core_route_table" "FoggyKitchenRouteTableViaNAT" {
    compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
    vcn_id = oci_core_virtual_network.FoggyKitchenVCN.id
    display_name = "FoggyKitchenRouteTableViaNAT"
    route_rules {
        destination = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
        network_entity_id = oci_core_nat_gateway.FoggyKitchenNATGateway.id
    }
}

resource "oci_core_subnet" "FoggyKitchenATPEndpointSubnet" {
  cidr_block = "10.0.2.0/24"
  display_name = "FoggyKitchenATPEndpointSubnet"
  dns_label = "fkN2"
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  vcn_id = oci_core_virtual_network.FoggyKitchenVCN.id
  route_table_id = oci_core_route_table.FoggyKitchenRouteTableViaNAT.id
  dhcp_options_id = oci_core_dhcp_options.FoggyKitchenDhcpOptions1.id
  prohibit_public_ip_on_vnic = true
}

resource "oci_core_subnet" "FoggyKitchenWebSubnet" {
  cidr_block = "10.0.1.0/24"
  display_name = "FoggyKitchenWebSubnet"
  dns_label = "fkN1"
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  vcn_id = oci_core_virtual_network.FoggyKitchenVCN.id
  route_table_id = oci_core_route_table.FoggyKitchenRouteTableViaIGW.id
  dhcp_options_id = oci_core_dhcp_options.FoggyKitchenDhcpOptions1.id
}