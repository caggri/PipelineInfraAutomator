resource "aws_vpc" "VPC" {
    cidr_block = "10.0.0.0/24"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    
  tags = {
    Name = "VPC"
    "Created by" = "${var.creator}"
    Automator = "Terraform"
  }
}

resource "aws_subnet" "Subnet1" {
    vpc_id = "${aws_vpc.VPC.id}"
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "${var.AZa}"

    tags = {
        Name = "Subnet1"
        "Created by" = "${var.creator}"
        Automator = "Terraform"
    }
}
