# Key Pair
variable "private_key" {
    default = "id_rsa"
}

variable "public_key" {
    default = "id_rsa.pub"
}

# Instance Settings
variable "jenkins_ami" {
    type = string
    default = "ami-05d34d340fb1d89e5"
}

variable "jenkins_instance_type" {
    type = string
    default = "t3a.nano"
}

variable "jenkins_nodes" {
    default = 2
}

variable "jfrog_ami" {
    type = string
    default = "ami-05d34d340fb1d89e5"
}

variable "jfrog_instance_type" {
    type = string
    default = "t3a.nano"
}

variable "instance_username" {
    type = string
    default = "ec2-user"
}

# VPC Settings
variable "region" {
    type = string
    default = "eu-central-1"
}

variable "subnet1" {
    type = string
    default = "subnet-09b468b8ca1e0c5d1"
}

variable "AZa" {
    type = string
    default = "eu-central-1a"
}

# Tags
variable "creator" {
    type = string
    default = "cagri.bayram"
}

