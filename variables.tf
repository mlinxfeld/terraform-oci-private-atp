variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "private_key_oci" {}
variable "public_key_oci" {}
variable "atp_password" {}

variable "VCN-CIDR" {
  default = "10.0.0.0/16"
}

variable "VCNname" {
  default = "FoggyKitchenVCN"
}

variable "ADs" {
  #default = ["unja:EU-FRANKFURT-1-AD-1", "unja:EU-FRANKFURT-1-AD-2", "unja:EU-FRANKFURT-1-AD-3"]
  default = ["uFjs:US-ASHBURN-AD-1", "uFjs:US-ASHBURN-AD-1", "uFjs:US-ASHBURN-AD-1"]
}

variable "Shapes" {
 default = ["VM.Standard.E2.1","VM.Standard.E2.1.Micro","VM.Standard2.1","VM.Standard.E2.1","VM.Standard.E2.2"]
}

variable "Images" {
 # Oracle-Linux-7.7-2020.02.21-0 in Frankfurt
 # default = ["ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa4cmgko5la45jui5cuju7byv6dgnfnjbxhwqxaei3q4zjwlliptuq"]

 # Oracle-Linux-7.7-2020.02.21-0 in Ashburn
 default = ["ocid1.image.oc1.iad.aaaaaaaavzjw65d6pngbghgrujb76r7zgh2s64bdl4afombrdocn4wdfrwdq"]
}

variable "webservice_ports" {
  default = ["80","443"]
}

variable "bastion_ports" {
  default = ["22"]
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

variable "FoggyKitchen_ATP_database_defined_tags_value" {
  default = "value"
}

variable "FoggyKitchen_ATP_database_display_name" {
  default = "FoggyKitchenATP"
}

variable "FoggyKitchen_ATP_database_freeform_tags" {
  default = {
    "Owner" = "FoggyKitchen"
  }
}

variable "FoggyKitchen_ATP_database_license_model" {
  default = "LICENSE_INCLUDED"
}

variable "FoggyKitchen_ATP_tde_wallet_zip_file" {
  default = "tde_wallet_fkatpdb1.zip"
}

variable "FoggyKitchen_ATP_database_atp_private_endpoint_label" {
  default = "FoggyKitchenATPPrivateEndpoint"
} 
