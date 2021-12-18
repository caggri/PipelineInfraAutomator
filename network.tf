resource "aws_internet_gateway" "InternetGateway" {
    vpc_id = "${aws_vpc.VPC.id}"

    tags = {
        Name = "InternetGateway"
        "Created by" = "${var.creator}"
        Automator = "Terraform"
    }
}

resource "aws_route_table" "RouteTable" {
    vpc_id = "${aws_vpc.VPC.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.InternetGateway.id}"
    }
    
    tags = {
        Name = "RouteTable"
        "Created by" = "${var.creator}"
        Automator = "Terraform"
    }
}


resource "aws_route_table_association" "Subnet1-Assoc" {
    subnet_id = "${aws_subnet.Subnet1.id}"
    route_table_id = "${aws_route_table.RouteTable.id}"
}

resource "aws_security_group" "SecurityGroupJenkins" {
    vpc_id = "${aws_vpc.VPC.id}"
    egress {
        from_port = 0
        to_port = 0
        protocol = -1 
        cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress {
    description      = "Allow SSH from Everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
   ingress {
    description      = "Allow HTTP from Everywhere"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
    tags = {
        Name = "SecurityGroupJenkins"
        "Created by" = "${var.creator}"
        Automator = "Terraform"
    }
}

resource "aws_security_group" "SecurityGroupJFrog" {
    vpc_id = "${aws_vpc.VPC.id}"
    egress {
        from_port = 0
        to_port = 0
        protocol = -1 
        cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress {
    description      = "Allow SSH from Everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
   ingress {
    description      = "Allow HTTP from Everywhere"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/24"]
    
  }
    tags = {
        Name = "SecurityGroupJFrog"
        "Created by" = "${var.creator}"
        Automator = "Terraform"
    }
}

