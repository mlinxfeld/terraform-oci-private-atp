resource "null_resource" "FoggyKitchenWebserver2_ConfigMgmt" {
  depends_on = [oci_core_instance.FoggyKitchenWebserver2, oci_database_autonomous_database.FoggyKitchenATPdatabaseRefreshableClone, local_file.FoggyKitchen_ATP_database_wallet_file2]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.FoggyKitchenWebserver2_VNIC1.public_ip_address
      private_key = file(var.private_key_oci)
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    inline = ["echo '== 1. Install Oracle instant client'",
      "sudo -u root yum -y install oracle-release-el7",
      "sudo -u root yum-config-manager --enable ol7_oracle_instantclient",
      "sudo -u root yum -y install oracle-instantclient18.3-basic",

      "echo '== 2. Install Python3, and then with pip3 cx_Oracle and flask'",
      "sudo -u root yum install -y python36",
      "sudo -u root pip3 install cx_Oracle",
      "sudo -u root pip3 install flask",
      "sudo -u root mkdir /tmp/templates/",
      "sudo -u root chown opc /tmp/templates/",

      "echo '== 3. Disabling firewall and starting HTTPD service'",
      "sudo -u root service firewalld stop"]
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.FoggyKitchenWebserver2_VNIC1.public_ip_address
      private_key = file(var.private_key_oci)
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "flask/sqlnet.ora"
    destination = "/tmp/sqlnet.ora"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.FoggyKitchenWebserver2_VNIC1.public_ip_address
      private_key = file(var.private_key_oci)
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = var.FoggyKitchen_ATP_tde_wallet_zip_file2
    destination = "/tmp/${var.FoggyKitchen_ATP_tde_wallet_zip_file2}"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.FoggyKitchenWebserver2_VNIC1.public_ip_address
      private_key = file(var.private_key_oci)
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "flask/flask_atp.py"
    destination = "/tmp/flask_atp.py"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.FoggyKitchenWebserver2_VNIC1.public_ip_address
      private_key = file(var.private_key_oci)
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "flask/flask_atp.sh"
    destination = "/tmp/flask_atp.sh"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.FoggyKitchenWebserver2_VNIC1.public_ip_address
      private_key = file(var.private_key_oci)
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "flask/templates/index.html"
    destination = "/tmp/templates/index.html"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.FoggyKitchenWebserver2_VNIC1.public_ip_address
      private_key = file(var.private_key_oci)
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    inline = ["echo '== 4. Unzip TDE wallet zip file'",
      "sudo -u root unzip -o /tmp/${var.FoggyKitchen_ATP_tde_wallet_zip_file2} -d /usr/lib/oracle/18.3/client64/lib/network/admin/",
      "echo '== 5. Move sqlnet.ora to /usr/lib/oracle/18.3/client64/lib/network/admin/'",
      "sudo -u root cp /tmp/sqlnet.ora /usr/lib/oracle/18.3/client64/lib/network/admin/"]
  }

}

resource "null_resource" "FoggyKitchenWebserver2_Query_Refreshable_Clone_ATP" {
  depends_on = [null_resource.FoggyKitchenWebserver2_ConfigMgmt, oci_database_autonomous_database.FoggyKitchenATPdatabaseRefreshableClone]

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.FoggyKitchenWebserver2_VNIC1.public_ip_address
      private_key = file(var.private_key_oci)
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "flask/query_source_atp.py"
    destination = "/tmp/query_source_atp.py"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.FoggyKitchenWebserver2_VNIC1.public_ip_address
      private_key = file(var.private_key_oci)
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "flask/query_source_atp.sh"
    destination = "/tmp/query_source_atp.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.FoggyKitchenWebserver2_VNIC1.public_ip_address
      private_key = file(var.private_key_oci)
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    inline = ["echo '== 6. Upload data to source ATP'",
      "sudo -u root python3 --version",
      "sudo -u root chmod +x /tmp/query_source_atp.sh",
      "sudo -u root sed -i 's/atp_password/${var.atp_password}/g' /tmp/query_source_atp.py",
      "sudo -u root sed -i 's/atp_alias/${var.FoggyKitchen_ATP_database_db_clone_name}_medium/g' /tmp/query_source_atp.py",
      "sudo -u root /tmp/query_source_atp.sh"
    ]
  }

}


resource "null_resource" "FoggyKitchenWebserver2_Flask_WebServer_and_access_ATP" {
  depends_on = [null_resource.FoggyKitchenWebserver2_Query_Refreshable_Clone_ATP]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.FoggyKitchenWebserver2_VNIC1.public_ip_address
      private_key = file(var.private_key_oci)
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    inline = ["echo '== 5. Run Flask with ATP access'",
      "sudo -u root python3 --version",
      "sudo -u root chmod +x /tmp/flask_atp.sh",
      "sudo -u root sed -i 's/atp_password/${var.atp_password}/g' /tmp/flask_atp.py",
      "sudo -u root sed -i 's/atp_alias/${var.FoggyKitchen_ATP_database_db_clone_name}_medium/g' /tmp/flask_atp.py",
      "sudo -u root nohup /tmp/flask_atp.sh > /tmp/flask_atp.log &",
      "sleep 5",
    "sudo -u root ps -ef | grep flask"]
  }

}
