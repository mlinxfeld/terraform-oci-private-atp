output "FoggyKitchenWebserver1_PublicIP" {
  value = [data.oci_core_vnic.FoggyKitchenWebserver1_VNIC1.public_ip_address]
}

output "FoggyKitchenWebserver2_PublicIP" {
  value = [data.oci_core_vnic.FoggyKitchenWebserver2_VNIC1.public_ip_address]
}

output "wallet_password" {
  value = [random_string.wallet_password.result]
}

output "FoggyKitchen_ATP_database_admin_password" {
   value = var.atp_password
}

output "FoggyKitchen_ATP_databases" {
  value = data.oci_database_autonomous_databases.FoggyKitchenATPdatabases.autonomous_databases
}

output "parallel_connection_string" {
  value = [lookup(oci_database_autonomous_database.FoggyKitchenATPdatabase.connection_strings.0.all_connection_strings, "PARALLEL", "Unavailable")]
}
