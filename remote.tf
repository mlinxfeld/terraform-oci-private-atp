data "template_file" "config_py_template1" {
  template = file("${path.module}/templates/config.template.py")
  vars = {
  }
}

data "template_file" "flask_ATP_py_template1" {
  template = file("${path.module}/templates/flask_ATP.template.py")
  vars = {
    ATP_USER_name                       = var.ATP_USER_name
    ATP_USER_password                   = var.ATP_USER_password
    ATP_alias                           = join("", [var.FoggyKitchen_ATP_database_db_name, "_medium"])
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
    dbname                              = var.FoggyKitchen_ATP_database_db_name
  }
}

data "template_file" "flask_ATP_py_template2" {
  template = file("${path.module}/templates/flask_ATP.template.py")
  vars = {
    ATP_USER_name                       = var.ATP_USER_name
    ATP_USER_password                   = var.ATP_USER_password
    ATP_alias                           = join("", [var.FoggyKitchen_ATP_database_db_clone_name, "_medium"])
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
    dbname                              = var.FoggyKitchen_ATP_database_db_clone_name
  }
}

data "template_file" "flask_ATP_service_template1" {
  template = file("${path.module}/templates/flask_ATP.template.service")
  vars = {
  }
}


data "template_file" "flask_ATP_sh_template1" {
  template = file("${path.module}/templates/flask_ATP.template.sh")
  vars = {
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
  }
}

data "template_file" "flask_bootstrap_sh_template1" {
  template = file("${path.module}/templates/flask_bootstrap.template.sh")
  vars = {
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
    ATP_tde_wallet_zip_file             = var.FoggyKitchen_ATP_tde_wallet_zip_file1
    ATP_private_ip                      = oci_database_autonomous_database.FoggyKitchenATPdatabase.private_endpoint_ip
    region                              = var.region
  }
}

data "template_file" "flask_bootstrap_sh_template2" {
  template = file("${path.module}/templates/flask_bootstrap.template.sh")
  vars = {
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
    ATP_tde_wallet_zip_file             = var.FoggyKitchen_ATP_tde_wallet_zip_file2
    ATP_private_ip                      = var.create_atp_refreshable_clone ? oci_database_autonomous_database.FoggyKitchenATPdatabaseRefreshableClone[0].private_endpoint_ip : ""
    region                              = var.region  
  }
}

data "template_file" "index_html_template1" {
  template = file("${path.module}/templates/index.template.html")
  vars = {
  }
}

data "template_file" "query_ATP_py_template1" {
  template = file("${path.module}/templates/query_ATP.template.py")
  vars = {
    ATP_USER_name                       = var.ATP_USER_name
    ATP_USER_password                   = var.ATP_USER_password
    ATP_alias                           = join("", [var.FoggyKitchen_ATP_database_db_name, "_medium"])
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
  }
}

data "template_file" "query_ATP_sh_template1" {
  template = file("${path.module}/templates/query_ATP.template.sh")
  vars = {
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
  }
}

data "template_file" "query_ATP_py_template2" {
  template = file("${path.module}/templates/query_ATP.template.py")
  vars = {
    ATP_USER_name                       = var.ATP_USER_name
    ATP_USER_password                   = var.ATP_USER_password
    ATP_alias                           = join("", [var.FoggyKitchen_ATP_database_db_clone_name, "_medium"])
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
  }
}

data "template_file" "query_ATP_sh_template2" {
  template = file("${path.module}/templates/query_ATP.template.sh")
  vars = {
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
  }
}

data "template_file" "sqlnet_ora_template1" {
  template = file("${path.module}/templates/sqlnet.template.ora")
  vars = {
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
  }
}

data "template_file" "update_ATP_py_template1" {
  template = file("${path.module}/templates/update_ATP.template.py")
  vars = {
    ATP_ADMIN_name                      = var.ATP_ADMIN_name
    ATP_ADMIN_password                  = var.ATP_ADMIN_password
    ATP_USER_name                       = var.ATP_USER_name
    ATP_USER_password                   = var.ATP_USER_password
    ATP_alias                           = join("", [var.FoggyKitchen_ATP_database_db_name, "_medium"])
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
  }
}

data "template_file" "update_ATP_sh_template1" {
  template = file("${path.module}/templates/update_ATP.template.sh")
  vars = {
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
  }
}

data "template_file" "update_ATP_2nd_time_py_template1" {
  template = file("${path.module}/templates/update_ATP_2nd_time.template.py")
  vars = {
    ATP_USER_name                       = var.ATP_USER_name
    ATP_USER_password                   = var.ATP_USER_password
    ATP_alias                           = join("", [var.FoggyKitchen_ATP_database_db_name, "_medium"])
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
  }
}

data "template_file" "update_ATP_2nd_time_sh_template1" {
  template = file("${path.module}/templates/update_ATP_2nd_time.template.sh")
  vars = {
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
  }
}

resource "null_resource" "FoggyKitchenWebserver1_ConfigMgmt" {
  depends_on = [oci_core_instance.FoggyKitchenWebserver1, oci_database_autonomous_database.FoggyKitchenATPdatabase, local_file.FoggyKitchen_ATP_database_wallet_file1]

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = var.FoggyKitchen_ATP_tde_wallet_zip_file1
    destination = "/tmp/${var.FoggyKitchen_ATP_tde_wallet_zip_file1}"
  }

  provisioner "local-exec" {
    command = "echo '${oci_database_autonomous_database_wallet.FoggyKitchen_ATP_database_wallet.content}' >> ${var.FoggyKitchen_ATP_tde_wallet_zip_file1}_encoded"
  }

  provisioner "local-exec" {
    command = "base64 --decode ${var.FoggyKitchen_ATP_tde_wallet_zip_file1}_encoded > ${var.FoggyKitchen_ATP_tde_wallet_zip_file1}"
  }

  provisioner "local-exec" {
    command = "rm -rf ${var.FoggyKitchen_ATP_tde_wallet_zip_file1}_encoded"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = var.FoggyKitchen_ATP_tde_wallet_zip_file1
    destination = "/tmp/${var.FoggyKitchen_ATP_tde_wallet_zip_file1}"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.config_py_template1.rendered
    destination = "/tmp/config.py"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.flask_ATP_py_template1.rendered
    destination = "/tmp/flask_ATP.py"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.flask_ATP_service_template1.rendered
    destination = "/tmp/flask_ATP.service"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.flask_ATP_sh_template1.rendered
    destination = "/tmp/flask_ATP.sh"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.index_html_template1.rendered
    destination = "/tmp/index.html"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.sqlnet_ora_template1.rendered
    destination = "/tmp/sqlnet.ora"
  }


  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.flask_bootstrap_sh_template1.rendered
    destination = "/tmp/flask_bootstrap.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    inline = [
    "chmod +x /tmp/flask_bootstrap.sh",
    "sudo /tmp/flask_bootstrap.sh"]
  }

}

resource "null_resource" "FoggyKitchenWebserver1_Update_Source_ATP" {
  depends_on = [null_resource.FoggyKitchenWebserver1_ConfigMgmt]

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.update_ATP_sh_template1.rendered
    destination = "/tmp/update_ATP.sh"
  }  

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.update_ATP_py_template1.rendered
    destination = "/tmp/update_ATP.py"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.update_ATP_2nd_time_sh_template1.rendered
    destination = "/tmp/update_ATP_2nd_time.sh"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.update_ATP_2nd_time_py_template1.rendered
    destination = "/tmp/update_ATP_2nd_time.py"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.query_ATP_sh_template1.rendered
    destination = "/tmp/query_ATP.sh"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.query_ATP_py_template1.rendered
    destination = "/tmp/query_ATP.py"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    inline = ["echo '== 9. Upload data to source ATP'",
      "sudo -u root python3 --version",
      "sudo -u root chmod +x /tmp/update_ATP.sh",
      "sudo -u root /tmp/update_ATP.sh",
      "sudo -u root chmod +x /tmp/query_ATP.sh",
      "sudo -u root /tmp/query_ATP.sh"
    ]
  }

}

resource "null_resource" "FoggyKitchenWebserver1_Update_Source_ATP_2nd_time" {
  count      = var.update_source_atp_data_2n_time ? 1 : 0
  depends_on = [null_resource.FoggyKitchenWebserver1_Update_Source_ATP]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver1.public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    inline = ["echo '== 10. Update data to source ATP 2nd time'",
      "sudo -u root python3 --version",
      "sudo -u root chmod +x /tmp/update_ATP_2nd_time.sh",
      "sudo -u root /tmp/update_ATP_2nd_time.sh",
      "sudo -u root chmod +x /tmp/query_ATP.sh",
      "sudo -u root /tmp/query_ATP.sh"
    ]
  }
}

resource "null_resource" "FoggyKitchenWebserver2_ConfigMgmt" {
  count      = var.create_atp_refreshable_clone ? 1 : 0
  depends_on = [oci_core_instance.FoggyKitchenWebserver2, oci_database_autonomous_database.FoggyKitchenATPdatabase, local_file.FoggyKitchen_ATP_database_wallet_file2]

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver2[0].public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = var.FoggyKitchen_ATP_tde_wallet_zip_file2
    destination = "/tmp/${var.FoggyKitchen_ATP_tde_wallet_zip_file2}"
  }

  provisioner "local-exec" {
    command = "echo '${oci_database_autonomous_database_wallet.FoggyKitchen_ATP_database_Refreshable_Clone_wallet[0].content}' >> ${var.FoggyKitchen_ATP_tde_wallet_zip_file2}_encoded"
  }

  provisioner "local-exec" {
    command = "base64 --decode ${var.FoggyKitchen_ATP_tde_wallet_zip_file2}_encoded > ${var.FoggyKitchen_ATP_tde_wallet_zip_file2}"
  }

  provisioner "local-exec" {
    command = "rm -rf ${var.FoggyKitchen_ATP_tde_wallet_zip_file2}_encoded"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver2[0].public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
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
      host        = oci_core_instance.FoggyKitchenWebserver2[0].public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.config_py_template1.rendered
    destination = "/tmp/config.py"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver2[0].public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.flask_ATP_py_template2.rendered
    destination = "/tmp/flask_ATP.py"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver2[0].public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.flask_ATP_service_template1.rendered
    destination = "/tmp/flask_ATP.service"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver2[0].public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.flask_ATP_sh_template1.rendered
    destination = "/tmp/flask_ATP.sh"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver2[0].public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.index_html_template1.rendered
    destination = "/tmp/index.html"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver2[0].public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.sqlnet_ora_template1.rendered
    destination = "/tmp/sqlnet.ora"
  }


  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver2[0].public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.flask_bootstrap_sh_template2.rendered
    destination = "/tmp/flask_bootstrap.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver2[0].public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    inline = [
    "chmod +x /tmp/flask_bootstrap.sh",
    "sudo /tmp/flask_bootstrap.sh"]
  }

}

resource "null_resource" "FoggyKitchenWebserver2_Query_Refreshable_Clone_ATP" {
  count      = var.create_atp_refreshable_clone ? 1 : 0
  depends_on = [null_resource.FoggyKitchenWebserver2_ConfigMgmt, oci_database_autonomous_database.FoggyKitchenATPdatabaseRefreshableClone]

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver2[0].public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.query_ATP_sh_template2.rendered
    destination = "/tmp/query_ATP.sh"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver2[0].public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    content     = data.template_file.query_ATP_py_template2.rendered
    destination = "/tmp/query_ATP.py"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.FoggyKitchenWebserver2[0].public_ip
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    inline = ["echo '== Query refreshable clone ATP'",
      "sudo -u root python3 --version",
      "sudo -u root chmod +x /tmp/query_ATP.sh",
      "sudo -u root /tmp/query_ATP.sh"
    ]
  }

}


