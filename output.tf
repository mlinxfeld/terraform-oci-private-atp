output "FoggyKitchenWebserver1_Connected_to_ATP_Instance_PublicIP" {
  value = [oci_core_instance.FoggyKitchenWebserver1.public_ip]
}

output "FoggyKitchenWebserver2_Connected_to_ATP_Refreshable_Clone_PublicIP" {
  value = [var.create_atp_refreshable_clone ? oci_core_instance.FoggyKitchenWebserver2[0].public_ip : ""]
}

# Generated Private Key for WebServer Instances
output "generated_ssh_private_key" {
  value     = tls_private_key.public_private_key_pair.private_key_pem
  sensitive = true
}

