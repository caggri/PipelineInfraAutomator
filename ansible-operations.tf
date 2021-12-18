resource "null_resource" "prepare_inventory_jenkins" {
  provisioner "local-exec" {
    command = "echo '[jenkins]' > ansible/inventory.ini"
  }
  depends_on = [
    aws_instance.jenkins_instances
  ]
}

resource "null_resource" "fetch_ips_jenkins" {
  count = 2
  provisioner "local-exec" {
    command = "echo '${aws_instance.jenkins_instances[count.index].public_ip}' >> ansible/inventory.ini"
  }
    depends_on = [
    null_resource.prepare_inventory_jenkins
  ]
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [aws_instance.jenkins_instances]
  create_duration = "30s"
}

resource "null_resource" after_party_jenkins {
  provisioner "local-exec" {
    command = "ansible jenkins -m ping -o -i ansible/inventory.ini -u ${var.instance_username} --key-file '${var.private_key}'"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ansible/inventory.ini ansible/jenkins.yml --key-file '${var.private_key}'"
  }
  depends_on = [time_sleep.wait_30_seconds]
}

#### JFrog Part

 resource "null_resource" "prepare_inventory_jfrog" {
  provisioner "local-exec" {
    command = "echo '[jfrog]' >> ansible/inventory.ini"
  }
  depends_on = [
    null_resource.fetch_ips_jenkins,
    aws_instance.jrog_instances,
  ]
}


resource "null_resource" "fetch_ip_jfrog" {
  provisioner "local-exec" {
    command = "echo '${aws_instance.jrog_instances.public_ip}' >> ansible/inventory.ini"
  }
  depends_on = [
    null_resource.prepare_inventory_jfrog
  ]
}

resource "null_resource" after_party_jfrog {
  provisioner "local-exec" {
    command = "ansible jfrog -m ping -o -i ansible/inventory.ini -u ${var.instance_username} --key-file '${var.private_key}'"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ansible/inventory.ini ansible/jfrog.yml --key-file '${var.private_key}'"
  }
  depends_on = [time_sleep.wait_30_seconds]
}