variable "aws_region" {
    description = "VPC region"
    default = "us-east-1"
}

variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

#variable "aws_region" {}
#  description = "Region for VPC"
#  default = "us-east-1"
#}

variable "vpc_cidr_dev" {
  description = "CIDR for dev VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_dev" {
  description = "CIDR for dev public subnet"
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr_dev" {
  description = "CIDR for dev private subnet"
  default = "10.0.2.0/24"
}


variable "vpc_cidr_prod" {
  description = "CIDR for prod VPC"
  default = "20.0.0.0/16"
}

variable "public_subnet_cidr_prod" {
  description = "CIDR for prod public subnet"
  default = "20.0.1.0/24"
}

variable "private_subnet_cidr_prod" {
  description = "CIDR for prod private subnet"
  default = "20.0.2.0/24"
}

variable "ami" {
  description = "AMI for EC2"
  default = "ami-4fffc834"
}


