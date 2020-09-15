resource "random_string" "wallet_password" {
  length  = 16
  special = true
}

resource "local_file" "FoggyKitchen_ATP_database_wallet_file" {
  content_base64  = data.oci_database_autonomous_database_wallet.FoggyKitchen_ATP_database_wallet.content
  filename = var.FoggyKitchen_ATP_tde_wallet_zip_file
}

resource "local_file" "FoggyKitchen_ATP_database_wallet_file2" {
  content_base64  = data.oci_database_autonomous_database_wallet.FoggyKitchen_ATP_database_Refreshable_Clone_wallet.content
  filename = var.FoggyKitchen_ATP_tde_wallet_zip_file2
}


