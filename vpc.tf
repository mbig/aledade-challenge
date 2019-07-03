# Define our Dev VPC
resource "aws_vpc" "dev-vpc" {
  cidr_block = "${var.vpc_cidr_dev}"
  enable_dns_hostnames = true

  tags {
    Name = "dev-vpc"
  }
}

# Define the public subnet
resource "aws_subnet" "dev-public-subnet" {
  vpc_id = "${aws_vpc.dev-vpc.id}"
  cidr_block = "${var.public_subnet_cidr_dev}"
  availability_zone = "us-east-1a"

  tags {
    Name = "Dev Public Subnet"
  }
}

# Define the private subnet
resource "aws_subnet" "dev-private-subnet" {
  vpc_id = "${aws_vpc.dev-vpc.id}"
  cidr_block = "${var.private_subnet_cidr_dev}"
  availability_zone = "us-east-1b"

  tags {
    Name = "Dev Private Subnet"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "dev-gw" {
  vpc_id = "${aws_vpc.dev-vpc.id}"

  tags {
    Name = "DEV VPC IGW"
  }
}

# Define the route table
resource "aws_route_table" "dev-public-rt" {
  vpc_id = "${aws_vpc.dev-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.dev-gw.id}"
  }

  tags {
    Name = "DEV Public Subnet RT"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "DEV-public-rt" {
  subnet_id = "${aws_subnet.dev-public-subnet.id}"
  route_table_id = "${aws_route_table.dev-public-rt.id}"
}

# Define the security group for public subnet
resource "aws_security_group" "dev-sgweb" {
  name = "vpc_DEV_web"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  vpc_id="${aws_vpc.dev-vpc.id}"

  tags {
    Name = "DEV Web SG"
  }
}

# Define the security group for private subnet
resource "aws_security_group" "dev-sgdb"{
  name = "sg_DEV_web"
  description = "Allow traffic from public subnet"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr_dev}"]
  }



  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr_dev}"]
  }

  vpc_id = "${aws_vpc.dev-vpc.id}"

  tags {
    Name = "Postgres SG"
  }
}
