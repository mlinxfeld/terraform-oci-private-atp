resource "oci_core_instance" "FoggyKitchenWebserver1" {
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name")
  compartment_id      = oci_identity_compartment.FoggyKitchenCompartment.id
  display_name        = "FoggyKitchenWebserver1"
  shape               = var.Shape

  dynamic "shape_config" {
    for_each = local.is_flexible_shape ? [1] : []
    content {
      memory_in_gbs = var.FlexShapeMemory
      ocpus         = var.FlexShapeOCPUS
    }
  }

  fault_domain = "FAULT-DOMAIN-1"

  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.OSImageLocal.images[0], "id")
  }
  metadata = {
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
  }
  create_vnic_details {
    subnet_id = oci_core_subnet.FoggyKitchenWebSubnet.id
    nsg_ids   = [oci_core_network_security_group.FoggyKitchenWebSecurityGroup.id, oci_core_network_security_group.FoggyKitchenSSHSecurityGroup.id]
  }
}

resource "oci_core_instance" "FoggyKitchenWebserver2" {
  count               = var.create_atp_refreshable_clone ? 1 : 0
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name")
  compartment_id      = oci_identity_compartment.FoggyKitchenCompartment.id
  display_name        = "FoggyKitchenWebServer2"
  shape               = var.Shape

  dynamic "shape_config" {
    for_each = local.is_flexible_shape ? [1] : []
    content {
      memory_in_gbs = var.FlexShapeMemory
      ocpus         = var.FlexShapeOCPUS
    }
  }
  
  fault_domain = "FAULT-DOMAIN-2"

  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.OSImageLocal.images[0], "id")
  }
  metadata = {
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
  }
  create_vnic_details {
    subnet_id = oci_core_subnet.FoggyKitchenWebSubnet.id
    nsg_ids   = [oci_core_network_security_group.FoggyKitchenWebSecurityGroup.id, oci_core_network_security_group.FoggyKitchenSSHSecurityGroup.id]
  }
}