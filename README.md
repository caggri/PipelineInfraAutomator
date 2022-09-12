# PipelineInfraAutomator
 ![Cover](https://s3.eu-central-1.amazonaws.com/caggri.com/images/cover.png)

This collection of tools will create a Jenkins Cluster on AWS. It will create a master node and multiple slave nodes



## Prerequisites - Required Software
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
* [Vault](https://www.vaultproject.io/downloads)
* [Packer](https://www.packer.io/downloads)
* [Terraform](https://www.terraform.io/downloads)
* [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)



## Prerequisites - Configuration
Make sure you have entered your aws credentials and set the default region by
```
aws configure
```

Run Vault Server by (dev environment is ok for our case)
```
vault server -dev
```

Recrord the password which will be used for admin user of Jenkins
```
vault kv put secret/jenkins-pass pass=<your-password>
```

You will need to pass token as environment variable. The token will be shown after vault server ready
```
export VAULT_TOKEN=<your-token>
```

Create or upload a public private key pair on AWS named <b>Jenkins</b> and add the private key to your system.

Get the subnet ID and security group ID and paste them into the relevant fields in Jenkins.pkr.hcl



## Running the Automation
Just type 
```
packer build -parallel-builds=1 jenkins.pkr.hcl   
```



## What does this Automation do?
* Retrieves the password from Vault
* Packer creates a Golden Image named jenkins-golden-image
    * Installs Jenkins and other required packages
    * Sets the admin password which will be taken from Vault
    * Installs Jenkins plugins
* Terraform creates instances by using AMI created by Packer
    * Fetches Public IPs of instanes
* Ansible adds Slaves to the Master
