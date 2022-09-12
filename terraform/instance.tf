data "aws_ami" "latest" {
  most_recent = true
  owners = ["self"]

  filter {
    name   = "name"
    values = ["jenkins-golden-image*"]
  }
}

resource "aws_instance" "jenkins_master" {
    ami = "${data.aws_ami.latest.id}"
    instance_type = "${var.jenkins_instance_type}"
    subnet_id = "${var.subnet}"
    key_name = "${var.key}"
    vpc_security_group_ids = ["${var.security_group}"]
    tags = {
      Name = "Jenkins Master Instance"
      Automator = "Terraform"
    } 
 }

resource "aws_instance" "jenkins_slaves" {
    count = "${var.jenkins_nodes}"
    ami = "${data.aws_ami.latest.id}"
    instance_type = "${var.jenkins_instance_type}"
    subnet_id = "${var.subnet}"
    key_name = "${var.key}"
    vpc_security_group_ids = ["${var.security_group}"]
    tags = {
      Name = "Jenkins Slave Instance ${count.index}"
      Automator = "Terraform"
    } 
 }

