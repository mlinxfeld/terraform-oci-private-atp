variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "ATP_ADMIN_password" {}
variable "ATP_USER_password" {}

variable "VCN-CIDR" {
  default = "10.0.0.0/16"
}

variable "VCNname" {
  default = "FoggyKitchenVCN"
}

variable "Shape" {
  default = "VM.Standard.E4.Flex"
}

variable "FlexShapeOCPUS" {
  default = 1
}

variable "FlexShapeMemory" {
  default = 1
}

variable "instance_os" {
  default = "Oracle Linux"
}

variable "linux_os_version" {
  default = "8"
}

variable "httpx_ports" {
  default = ["80", "443"]
}

variable "ATP_ADMIN_name" {
  default = "admin"
}

variable "ATP_USER_name" {
  default = "atp_user"
}

variable "FoggyKitchen_ATP_database_cpu_core_count" {
  default = 1
}

variable "FoggyKitchen_ATP_database_data_storage_size_in_tbs" {
  default = 1
}

variable "FoggyKitchen_ATP_database_db_name" {
  default = "fkatpdb1"
}

variable "FoggyKitchen_ATP_database_db_version" {
  default = "19c"
}

variable "FoggyKitchen_ATP_database_db_clone_name" {
  default = "fkatpdb2"
}

variable "FoggyKitchen_ATP_database_db_clone_from_backup_name" {
  default = "fkatpdb3"
}

variable "FoggyKitchen_ATP_database_defined_tags_value" {
  default = "value"
}

variable "FoggyKitchen_ATP_database_display_name" {
  default = "FoggyKitchenATP"
}

variable "FoggyKitchen_ATP_database_display_clone_name" {
  default = "FoggyKitchenATPClone"
}

variable "FoggyKitchen_ATP_database_display_refreshable_clone_name" {
  default = "FoggyKitchenATPRefreshableClone"
}

variable "FoggyKitchen_ATP_database_display_clone_from_backup_name" {
  default = "FoggyKitchenATPCloneFromBackup"
}

variable "FoggyKitchen_ATP_database_freeform_tags" {
  default = {
    "Owner" = "FoggyKitchen"
  }
}

variable "FoggyKitchen_ATP_database_license_model" {
  default = "LICENSE_INCLUDED"
}

variable "FoggyKitchen_ATP_tde_wallet_zip_file1" {
  default = "tde_wallet_fkatpdb1.zip"
}

variable "FoggyKitchen_ATP_tde_wallet_zip_file2" {
  default = "tde_wallet_fkatpdb2.zip"
}

variable "FoggyKitchen_ATP_database_atp_private_endpoint_label" {
  default = "FoggyKitchenATPPrivateEndpoint"
}


variable "FoggyKitchen_ATP_database_atp_clone_private_endpoint_label" {
  default = "FoggyKitchenATPClonePrivateEndpoint"
}

variable "FoggyKitchen_ATP_database_atp_clone_from_backup_private_endpoint_label" {
  default = "FoggyKitchenATPCloneFromBackupPrivateEndpoint"
}

variable "create_atp_refreshable_clone" {
  default = false
}

variable "update_source_atp_data_2n_time" {
  default = false
}

variable "create_atp_clone" {
  default = false
}

variable "create_atp_clone_from_backup" {
  default = false
}

variable "oracle_instant_client_version" {
  default = "19.10"
}

variable "oracle_instant_client_version_short" {
  default = "19.10"
}


# Dictionary Locals
locals {
  compute_flexible_shapes = [
    "VM.Standard.E3.Flex",
    "VM.Standard.E4.Flex"
  ]
}

# Checks if is using Flexible Compute Shapes
locals {
  is_flexible_shape    = contains(local.compute_flexible_shapes, var.Shape)
}
