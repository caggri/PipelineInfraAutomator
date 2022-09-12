resource "null_resource" "master" {
  provisioner "local-exec" {
    command = "echo '[master]' > ansible/inventory.ini"
  }
}


resource "null_resource" "fetch_master_ip" {

  provisioner "local-exec" {
    command = "echo '${aws_instance.jenkins_master.public_ip}' >> ansible/inventory.ini"
  }
    depends_on = [
    null_resource.master
  ]
}


resource "null_resource" "slave" {
  provisioner "local-exec" {
    command = "echo '[slave]' >> ansible/inventory.ini"
  }
    depends_on = [

    null_resource.master,
    null_resource.fetch_master_ip
  ]
}


resource "null_resource" "fetch_ips_jenkins" {
  count = "${var.jenkins_nodes}"
  provisioner "local-exec" {
    command = "echo '${aws_instance.jenkins_slaves[count.index].public_ip}' >> ansible/inventory.ini"
  }
    depends_on = [

    null_resource.master,
    null_resource.fetch_master_ip,
    null_resource.slave
  ]
}

resource "time_sleep" "wait_for_resources_gettng_ready" {
  depends_on = [aws_instance.jenkins_slaves]
  create_duration = "30s"
}

resource "null_resource" "Generate_Slave_Keys" {
  provisioner "local-exec" {
    command = "ssh-keygen  -b 2048 -q -t rsa -N '' -f ./ansible/keys/slave_key <<<y"
  }

  depends_on = [time_sleep.wait_for_resources_gettng_ready]
}


resource "null_resource" "Run_Ansible_to_Add_Slaves_to_Cluster" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ansible/inventory.ini ansible/add_slave.yml --key-file ${var.key}.pem --extra-vars \"password=${var.pass}\""
  }
  depends_on = [null_resource.Generate_Slave_Keys]
}


resource "null_resource" "Clear_Keys" {
  provisioner "local-exec" {
    command = "rm -f ./ansible/keys/slave_key*"
    when    = destroy
  }

}
