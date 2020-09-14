resource "null_resource" "FoggyKitchenWebserver1_Update_Source_ATP" {
  depends_on = [null_resource.FoggyKitchenWebserver1_ConfigMgmt]

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.FoggyKitchenWebserver1_VNIC1.public_ip_address
      private_key = file(var.private_key_oci)
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "update_source_atp.py"
    destination = "/tmp/update_source_atp.py"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.FoggyKitchenWebserver1_VNIC1.public_ip_address
      private_key = file(var.private_key_oci)
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "update_source_atp.sh"
    destination = "/tmp/update_source_atp.sh"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.FoggyKitchenWebserver1_VNIC1.public_ip_address
      private_key = file(var.private_key_oci)
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "query_source_atp.py"
    destination = "/tmp/query_source_atp.py"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.FoggyKitchenWebserver1_VNIC1.public_ip_address
      private_key = file(var.private_key_oci)
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    source      = "query_source_atp.sh"
    destination = "/tmp/query_source_atp.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.FoggyKitchenWebserver1_VNIC1.public_ip_address
      private_key = file(var.private_key_oci)
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    inline = ["echo '== 7. Upload data to source Run Flask with ATP access'",
      "sudo -u root python3 --version",
      "sudo -u root chmod +x /tmp/update_source_atp.sh",
      "sudo -u root sed -i 's/atp_password/${var.atp_password}/g' /tmp/update_source_atp.py",
      "sudo -u root /tmp/update_source_atp.sh",
      "sudo -u root chmod +x /tmp/query_source_atp.sh",
      "sudo -u root sed -i 's/atp_password/${var.atp_password}/g' /tmp/query_source_atp.py",
      "sudo -u root /tmp/query_source_atp.sh"
    ]
  }

}

