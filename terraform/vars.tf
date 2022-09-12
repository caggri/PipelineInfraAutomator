variable "pass" {} //Don't delete this variable.
variable "subnet" {} //Don't delete this variable.
variable "jenkins_nodes" {} //Don't delete this variable. 
variable "security_group" {}  //Don't delete this variable.
variable "jenkins_instance_type" {} //Don't delete this variable.

variable "key" {
    type = string
    default = "Jenkins"
}


