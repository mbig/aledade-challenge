# Define our Dev VPC
resource "aws_vpc" "dev-vpc" {
  cidr_block = "${var.vpc_cidr_dev}"
  enable_dns_hostnames = true

  tags {
    Name = "dev-vpc"
  }
}

# Define dev public subnet
resource "aws_subnet" "dev-public-subnet" {
  vpc_id = "${aws_vpc.dev-vpc.id}"
  cidr_block = "${var.public_subnet_cidr_dev}"
  availability_zone = "us-east-1a"

  tags {
    Name = "Dev Public Subnet"
  }
}

# Define dev private subnet
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
    Name = "dev Public Subnet RT"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "dev-public-rt" {
  subnet_id = "${aws_subnet.dev-public-subnet.id}"
  route_table_id = "${aws_route_table.dev-public-rt.id}"
}

# Define the security group for dev public subnet
resource "aws_security_group" "dev-sgweb" {
  name = "vpc_dev_web"
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

# Define the security group for dev private subnet
resource "aws_security_group" "dev-sgdb"{
  name = "sg_dev_db"
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
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.dev-vpc.id}"

  tags {
    Name = "DEV Postgres SG"
  }
}


# Define  prod VPC
resource "aws_vpc" "prod-vpc" {
  cidr_block = "${var.vpc_cidr_prod}"
  enable_dns_hostnames = true

  tags {
    Name = "prod-vpc"
  }
}

# Define prod public subnet
resource "aws_subnet" "prod-public-subnet" {
  vpc_id = "${aws_vpc.prod-vpc.id}"
  cidr_block = "${var.public_subnet_cidr_prod}"
  availability_zone = "us-east-1c"

  tags {
    Name = "prod Public Subnet"
  }
}

# Define  Prod private subnet
resource "aws_subnet" "prod-private-subnet" {
  vpc_id = "${aws_vpc.prod-vpc.id}"
  cidr_block = "${var.private_subnet_cidr_prod}"
  availability_zone = "us-east-1d"

  tags {
    Name = "prod Private Subnet"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "prod-gw" {
  vpc_id = "${aws_vpc.prod-vpc.id}"

  tags {
    Name = "prod VPC IGW"
  }
}

# Define the route table
resource "aws_route_table" "prod-public-rt" {
  vpc_id = "${aws_vpc.prod-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.prod-gw.id}"
  }

  tags {
    Name = "prod Public Subnet RT"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "prod-public-rt" {
  subnet_id = "${aws_subnet.prod-public-subnet.id}"
  route_table_id = "${aws_route_table.prod-public-rt.id}"
}

# Define the security group for public subnet
resource "aws_security_group" "prod-sgweb" {
  name = "vpc_prod_web"
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

  vpc_id="${aws_vpc.prod-vpc.id}"

  tags {
    Name = "prod Web SG"
  }
}

# Define the security group for prod private subnet
resource "aws_security_group" "prod-sgdb"{
  name = "sg_prod_db"
  description = "Allow traffic from public subnet"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr_prod}"]
  }



  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.prod-vpc.id}"

  tags {
    Name = "Prod Postgres SG"
  }
}
