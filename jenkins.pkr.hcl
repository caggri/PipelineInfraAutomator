locals {
    pass = vault("/secret/data/jenkins-pass", "pass")
    subnet = ""
	slaves = 2 //number of slaves
    security_gorup = ""
    jenkins_instance_type = "t3a.medium"
    region = ""
}

source "amazon-ebs" "jenkins" {
    region = "${local.region}"
    ami_name = "jenkins-golden-image"

    source_ami_filter {
        filters = {
            virtualization-type = "hvm"
            name = "amzn2-ami-hvm-2.0.*-gp2"
            root-device-type = "ebs"
        }
        owners = ["amazon"]
        most_recent = true
    }

    instance_type = "t3.medium"
    ssh_username = "ec2-user"
    
}

build {
    sources = ["source.amazon-ebs.jenkins"]

    provisioner "file" {
        source = "init.sh"
        destination = "/tmp/init.sh"
    }

    provisioner "shell" {
        inline = [
        "sudo bash /tmp/init.sh ${local.pass}"
        ]
    }
}


source "null" "basic-example" {
    communicator = "none"
}

build {
  sources = ["sources.null.basic-example"]


      provisioner "shell-local" {
        inline = [
        "echo 'Initializing Terraform'",
        "terraform -chdir=terraform/ init &> /dev/null",
        "terraform -chdir=terraform/ apply -auto-approve -var 'pass=${local.pass}' -var 'jenkins_instance_type=${local.jenkins_instance_type}' -var 'subnet=${local.subnet}' -var 'jenkins_nodes=${local.slaves}' -var 'security_group=${local.security_gorup}'"
        ]
  }
}


