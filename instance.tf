resource "aws_key_pair" "KeyPair" {
    key_name = "private_key"
    public_key = "${file("${var.public_key}")}"
}

resource "aws_instance" "jenkins_instances" {
    count = "${var.jenkins_nodes}"
    ami = "${var.jenkins_ami}"
    instance_type = "${var.jenkins_instance_type}"
    subnet_id = "${aws_subnet.Subnet1.id}"
    key_name = "${aws_key_pair.KeyPair.key_name}"
    vpc_security_group_ids = ["${aws_security_group.SecurityGroupJenkins.id}"]
    tags = {
      Name = "Jenkins Instance ${count.index}"
      "Created by" = "${var.creator}"
      Automator = "Terraform"
    } 
 }

resource "aws_instance" "jrog_instances" {
    ami = "${var.jfrog_ami}"
    instance_type = "${var.jfrog_instance_type}"
    subnet_id = "${aws_subnet.Subnet1.id}"
    key_name = "${aws_key_pair.KeyPair.key_name}"
    vpc_security_group_ids = ["${aws_security_group.SecurityGroupJFrog.id}"]
    tags = {
      Name = "JFrog Artifactory"
      "Created by" = "${var.creator}"
      Automator = "Terraform"
    } 
 }

