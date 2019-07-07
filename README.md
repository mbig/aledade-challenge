# aledade-challenge

## How to run this program

## Local system prerequisites  

    ##### Launch an AWS EC2 AMI2 instance
    ##### Install ansible (sudo amazon-linux-extras install ansible2)  
    ##### Install python2-pip and git (yum install python2-pip git)
    ##### Install boto (pip install boto)
    ##### Terraform (Terraform v0.11.8) - Use this version, looks other versions may show some bugs
          https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip
    

###### Git clone the repository: https://github.com/mbig/aledade-challenge.git
###### cd aledade-challenge
###### wget https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip
###### unzip terraform_0.11.8_linux_amd64.zip
###### Edit the vars.tf file and update region, vpc cidr, subnets as needed. Also make sure ec2-user has public and private keys or any user you are using(ssh-keygen)

###### Run terraform init to download plugins(./terraform init)
###### Run terraform apply(./terraform apply)
###### Enter Access key ID and Secret access key when prompted.


