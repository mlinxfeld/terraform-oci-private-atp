# Home Region Subscription DataSource
data "oci_identity_region_subscriptions" "home_region_subscriptions" {
  tenancy_id = var.tenancy_ocid

  filter {
    name   = "is_home_region"
    values = [true]
  }
}

# Gets a list of Availability Domains
data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_ocid
}

# Gets the Id of a specific OS Images
data "oci_core_images" "OSImageLocal" {
  compartment_id           = var.compartment_ocid
  operating_system         = var.instance_os
  operating_system_version = var.linux_os_version
  shape                    = var.Shape

  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}

data "oci_database_autonomous_databases" "FoggyKitchenATPdatabases" {
  compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
  display_name = var.FoggyKitchen_ATP_database_display_name
}

