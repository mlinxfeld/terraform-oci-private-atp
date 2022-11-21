resource "oci_database_autonomous_database" "FoggyKitchenATPdatabase" {
  admin_password           = var.ATP_ADMIN_password
  compartment_id           = oci_identity_compartment.FoggyKitchenCompartment.id
  cpu_core_count           = var.FoggyKitchen_ATP_database_cpu_core_count
  data_storage_size_in_tbs = var.FoggyKitchen_ATP_database_data_storage_size_in_tbs
  db_name                  = var.FoggyKitchen_ATP_database_db_name
  db_version               = var.FoggyKitchen_ATP_database_db_version
  display_name             = var.FoggyKitchen_ATP_database_display_name
  freeform_tags            = var.FoggyKitchen_ATP_database_freeform_tags
  license_model            = var.FoggyKitchen_ATP_database_license_model
  nsg_ids                  = [oci_core_network_security_group.FoggyKitchenATPSecurityGroup.id]   
  private_endpoint_label   = var.FoggyKitchen_ATP_database_atp_private_endpoint_label
  subnet_id                = oci_core_subnet.FoggyKitchenATPEndpointSubnet.id      
}

resource "oci_database_autonomous_database_wallet" "FoggyKitchen_ATP_database_wallet" {
  autonomous_database_id = oci_database_autonomous_database.FoggyKitchenATPdatabase.id
  password               = random_string.wallet_password.result
  base64_encode_content  = "true"
}

resource "oci_database_autonomous_database" "FoggyKitchenATPdatabaseRefreshableClone" {
  depends_on = [null_resource.FoggyKitchenWebserver1_Update_Source_ATP] 
  count                    = var.create_atp_refreshable_clone ? 1 : 0
  source                   = "CLONE_TO_REFRESHABLE"
  source_id                = oci_database_autonomous_database.FoggyKitchenATPdatabase.id
  refreshable_mode         = "MANUAL"
  admin_password           = ""
  compartment_id           = oci_identity_compartment.FoggyKitchenCompartment.id
  cpu_core_count           = var.FoggyKitchen_ATP_database_cpu_core_count
  data_storage_size_in_tbs = var.FoggyKitchen_ATP_database_data_storage_size_in_tbs
  db_name                  = var.FoggyKitchen_ATP_database_db_clone_name
  db_version               = var.FoggyKitchen_ATP_database_db_version
  display_name             = var.FoggyKitchen_ATP_database_display_refreshable_clone_name
  freeform_tags            = var.FoggyKitchen_ATP_database_freeform_tags
  license_model            = var.FoggyKitchen_ATP_database_license_model
  nsg_ids                  = [oci_core_network_security_group.FoggyKitchenATPSecurityGroup.id]   
  private_endpoint_label   = var.FoggyKitchen_ATP_database_atp_clone_private_endpoint_label
  subnet_id                = oci_core_subnet.FoggyKitchenATPEndpointSubnet.id      
}

resource "oci_database_autonomous_database_wallet" "FoggyKitchen_ATP_database_Refreshable_Clone_wallet" {
  count                  = var.create_atp_refreshable_clone ? 1 : 0
  autonomous_database_id = oci_database_autonomous_database.FoggyKitchenATPdatabaseRefreshableClone[0].id
  password               = random_string.wallet_password.result
  base64_encode_content  = "true"
}


resource "oci_database_autonomous_database" "FoggyKitchenATPdatabaseClone" {
  count                    = var.create_atp_clone ? 1 : 0
  source                   = "DATABASE"
  source_id                = oci_database_autonomous_database.FoggyKitchenATPdatabase.id
  clone_type               = "FULL"

  admin_password           = var.ATP_ADMIN_password
  compartment_id           = oci_identity_compartment.FoggyKitchenCompartment.id
  cpu_core_count           = var.FoggyKitchen_ATP_database_cpu_core_count
  data_storage_size_in_tbs = var.FoggyKitchen_ATP_database_data_storage_size_in_tbs
  db_name                  = var.FoggyKitchen_ATP_database_db_clone_name
  db_version               = var.FoggyKitchen_ATP_database_db_version
  display_name             = var.FoggyKitchen_ATP_database_display_clone_name
  freeform_tags            = var.FoggyKitchen_ATP_database_freeform_tags
  license_model            = var.FoggyKitchen_ATP_database_license_model
  nsg_ids                  = [oci_core_network_security_group.FoggyKitchenATPSecurityGroup.id]   
  private_endpoint_label   = var.FoggyKitchen_ATP_database_atp_clone_private_endpoint_label
  subnet_id                = oci_core_subnet.FoggyKitchenATPEndpointSubnet.id      
}

data "oci_database_autonomous_database_backups" "FoggyKitchenATPdatabaseBackups" {
    count                  = var.create_atp_clone_from_backup ? 1 : 0
    autonomous_database_id = oci_database_autonomous_database.FoggyKitchenATPdatabase.id
}

resource "oci_database_autonomous_database" "FoggyKitchenATPdatabaseCloneFromBackup" {
  count                         = var.create_atp_clone_from_backup ? 1 : 0
  source                        = "BACKUP_FROM_ID"
  source_id                     = oci_database_autonomous_database.FoggyKitchenATPdatabase.id
  clone_type                    = "FULL"
  autonomous_database_backup_id = lookup(data.oci_database_autonomous_database_backups.FoggyKitchenATPdatabaseBackups[0].autonomous_database_backups[0], "id")

  admin_password                = var.ATP_ADMIN_password
  compartment_id                = oci_identity_compartment.FoggyKitchenCompartment.id
  cpu_core_count                = var.FoggyKitchen_ATP_database_cpu_core_count
  data_storage_size_in_tbs      = var.FoggyKitchen_ATP_database_data_storage_size_in_tbs
  db_name                       = var.FoggyKitchen_ATP_database_db_clone_from_backup_name
  db_version                    = var.FoggyKitchen_ATP_database_db_version
  display_name                  = var.FoggyKitchen_ATP_database_display_clone_from_backup_name
  freeform_tags                 = var.FoggyKitchen_ATP_database_freeform_tags
  license_model                 = var.FoggyKitchen_ATP_database_license_model
  nsg_ids                       = [oci_core_network_security_group.FoggyKitchenATPSecurityGroup.id]   
  private_endpoint_label        = var.FoggyKitchen_ATP_database_atp_clone_from_backup_private_endpoint_label
  subnet_id                     = oci_core_subnet.FoggyKitchenATPEndpointSubnet.id      
}

resource "random_string" "wallet_password" {
  length  = 16
  special = true
}

resource "local_file" "FoggyKitchen_ATP_database_wallet_file1" {
  content_base64  = oci_database_autonomous_database_wallet.FoggyKitchen_ATP_database_wallet.content
  filename        = var.FoggyKitchen_ATP_tde_wallet_zip_file1
}

resource "local_file" "FoggyKitchen_ATP_database_wallet_file2" {
  count           = var.create_atp_refreshable_clone ? 1 : 0
  content_base64  = oci_database_autonomous_database_wallet.FoggyKitchen_ATP_database_Refreshable_Clone_wallet[0].content
  filename        = var.FoggyKitchen_ATP_tde_wallet_zip_file2
}

