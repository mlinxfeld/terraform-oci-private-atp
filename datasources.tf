# Gets a list of Availability Domains
data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_ocid
}

# Gets the Id of a specific OS Images
data "oci_core_images" "OSImageLocal" {
  #Required
  compartment_id = var.compartment_ocid
  display_name   = var.OsImage
}

data "oci_core_vnic_attachments" "FoggyKitchenWebserver1_VNIC1_attach" {
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name")
  compartment_id      = oci_identity_compartment.FoggyKitchenCompartment.id
  instance_id         = oci_core_instance.FoggyKitchenWebserver1.id
}

data "oci_core_vnic" "FoggyKitchenWebserver1_VNIC1" {
  vnic_id = data.oci_core_vnic_attachments.FoggyKitchenWebserver1_VNIC1_attach.vnic_attachments.0.vnic_id
}

data "oci_core_vnic_attachments" "FoggyKitchenWebserver2_VNIC1_attach" {
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name")
  compartment_id      = oci_identity_compartment.FoggyKitchenCompartment.id
  instance_id         = oci_core_instance.FoggyKitchenWebserver2.id
}

data "oci_core_vnic" "FoggyKitchenWebserver2_VNIC1" {
  vnic_id = data.oci_core_vnic_attachments.FoggyKitchenWebserver2_VNIC1_attach.vnic_attachments.0.vnic_id
}

data "oci_database_autonomous_databases" "FoggyKitchenATPdatabases" {
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  display_name = var.FoggyKitchen_ATP_database_display_name
}

data "oci_database_autonomous_database_wallet" "FoggyKitchen_ATP_database_Refreshable_Clone_wallet" {
  autonomous_database_id = oci_database_autonomous_database.FoggyKitchenATPdatabaseRefreshableClone.id
  password               = random_string.wallet_password.result
  base64_encode_content  = "true"
}

data "oci_database_autonomous_database_wallet" "FoggyKitchen_ATP_database_wallet" {
  autonomous_database_id = oci_database_autonomous_database.FoggyKitchenATPdatabase.id
  password               = random_string.wallet_password.result
  base64_encode_content  = "true"
}