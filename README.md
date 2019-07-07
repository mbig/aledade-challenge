# aledade-challenge

## How to run this program

    ##### Launch an AWS EC2 AMI2 instance
    ##### Install git (sudo yum install git -y )
    ##### Clone code repo (git clone https://github.com/mbig/aledade-challenge.git)
    ##### cd aledade-challenge
    ##### chmod u+x setup.sh
    ##### Run setup script(./setup.sh) -- This will install ansible, python2-pip, terraform, boto, create ssh-keys, terraform init) - hit n if ssh-keys already exists
    ##### Edit the vars.tf file and update region, vpc cidr, subnets as needed.
    ##### terraform apply
    ##### Enter Access key ID and Secret access key when prompted
    ##### Enter "yes" to perform terraform actions.
    ##### terraform destroy (This will destroy the environment)
    ##### Terminate EC2 instance
    

