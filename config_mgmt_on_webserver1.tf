resource "null_resource" "FoggyKitchenWebserver1_ConfigMgmt" {
 depends_on = [oci_core_instance.FoggyKitchenWebserver1, oci_core_instance.FoggyKitchenBastionServer, oci_database_autonomous_database.FoggyKitchenATPdatabase, local_file.FoggyKitchen_ATP_database_wallet_file]
 
 provisioner "remote-exec" {
        connection {
                type     = "ssh"
                user     = "opc"
		        host     = data.oci_core_vnic.FoggyKitchenWebserver1_VNIC1.private_ip_address
                private_key = file(var.private_key_oci)
                script_path = "/home/opc/myssh.sh"
                agent = false
                timeout = "10m"
                bastion_host = data.oci_core_vnic.FoggyKitchenBastionServer_VNIC1.public_ip_address
                bastion_port = "22"
                bastion_user = "opc"
                bastion_private_key = file(var.private_key_oci)
        }
  inline = ["echo '== 1. Installing HTTPD package with yum'",
            "sudo -u root yum -y -q install httpd",

            "echo '== 2. Creating /var/www/html/index.html'",
            "sudo -u root touch /var/www/html/index.html", 
            "sudo /bin/su -c \"echo 'Welcome to FoggyKitchen.com! This is WEBSERVER1...' > /var/www/html/index.html\"",

            "echo '== 3. Disabling firewall and starting HTTPD service'",
            "sudo -u root service firewalld stop",
            "sudo -u root service httpd start",

            "echo '== 4. Install Oracle instant client'",
            "sudo -u root yum -y install oracle-release-el7",
            "sudo -u root yum-config-manager --enable ol7_oracle_instantclient",
            "sudo -u root yum -y install oracle-instantclient18.3-basic",
            "sudo -u root yum -y install oracle-instantclient18.3-sqlplus"]
  }

  provisioner "file" {
    connection {
                type     = "ssh"
                user     = "opc"
                host     = data.oci_core_vnic.FoggyKitchenWebserver1_VNIC1.private_ip_address
                private_key = file(var.private_key_oci)
                script_path = "/home/opc/myssh.sh"
                agent = false
                timeout = "10m"
                bastion_host = data.oci_core_vnic.FoggyKitchenBastionServer_VNIC1.public_ip_address
                bastion_port = "22"
                bastion_user = "opc"
                bastion_private_key = file(var.private_key_oci)
        }
    source     = "sqlnet.ora"
    destination = "/tmp/sqlnet.ora"
  }

  provisioner "file" {
    connection {
                type     = "ssh"
                user     = "opc"
                host     = data.oci_core_vnic.FoggyKitchenWebserver1_VNIC1.private_ip_address
                private_key = file(var.private_key_oci)
                script_path = "/home/opc/myssh.sh"
                agent = false
                timeout = "10m"
                bastion_host = data.oci_core_vnic.FoggyKitchenBastionServer_VNIC1.public_ip_address
                bastion_port = "22"
                bastion_user = "opc"
                bastion_private_key = file(var.private_key_oci)
        }
    source     = "${var.FoggyKitchen_ATP_tde_wallet_zip_file}"
    destination = "/tmp/${var.FoggyKitchen_ATP_tde_wallet_zip_file}"
  }

   provisioner "file" {
    connection {
                type     = "ssh"
                user     = "opc"
                host     = data.oci_core_vnic.FoggyKitchenWebserver1_VNIC1.private_ip_address
                private_key = file(var.private_key_oci)
                script_path = "/home/opc/myssh.sh"
                agent = false
                timeout = "10m"
                bastion_host = data.oci_core_vnic.FoggyKitchenBastionServer_VNIC1.public_ip_address
                bastion_port = "22"
                bastion_user = "opc"
                bastion_private_key = file(var.private_key_oci)
        }
    source     = "check_atp.sh"
    destination = "/tmp/check_atp.sh"
  }

  provisioner "remote-exec" {
        connection {
                type     = "ssh"
                user     = "opc"
                host     = data.oci_core_vnic.FoggyKitchenWebserver1_VNIC1.private_ip_address
                private_key = file(var.private_key_oci)
                script_path = "/home/opc/myssh.sh"
                agent = false
                timeout = "10m"
                bastion_host = data.oci_core_vnic.FoggyKitchenBastionServer_VNIC1.public_ip_address
                bastion_port = "22"
                bastion_user = "opc"
                bastion_private_key = file(var.private_key_oci)
        }
  inline = ["echo '== 5. Move sqlnet.ora to /usr/lib/oracle/18.3/client64/lib/network/admin/'",
            "sudo -u root mv /tmp/sqlnet.ora /usr/lib/oracle/18.3/client64/lib/network/admin/",

            "echo '== 6. Move TDE wallet zip file to /usr/lib/oracle/18.3/client64/lib/network/admin/'",
            "sudo -u root mv /tmp/${var.FoggyKitchen_ATP_tde_wallet_zip_file} /usr/lib/oracle/18.3/client64/lib/network/admin/"]
  }

}

resource "null_resource" "FoggyKitchenWebserver1_SQLPLUS_to_ATP" {
 depends_on = [null_resource.FoggyKitchenWebserver1_ConfigMgmt]

provisioner "remote-exec" {
        connection {
                type     = "ssh"
                user     = "opc"
                host     = data.oci_core_vnic.FoggyKitchenWebserver1_VNIC1.private_ip_address
                private_key = file(var.private_key_oci)
                script_path = "/home/opc/myssh.sh"
                agent = false
                timeout = "10m"
                bastion_host = data.oci_core_vnic.FoggyKitchenBastionServer_VNIC1.public_ip_address
                bastion_port = "22"
                bastion_user = "opc"
                bastion_private_key = file(var.private_key_oci)
        }
  inline = ["echo '== 7. Access ATP via SQLPLUS'",
            "sudo -u root /tmp/check_atp.sh"]
  }

}
