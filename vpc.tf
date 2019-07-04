# Define  Dev VPC
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
  map_public_ip_on_launch = true

  tags {
    Name = "dev-public-subnet"
  }
}

# Define dev private subnet
resource "aws_subnet" "dev-private-subnet" {
  vpc_id = "${aws_vpc.dev-vpc.id}"
  cidr_block = "${var.private_subnet_cidr_dev}"
  availability_zone = "us-east-1b"

  tags {
    Name = "dev-private-subnet"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "dev-gw" {
  vpc_id = "${aws_vpc.dev-vpc.id}"

  tags {
    Name = "dev-vpc-igw"
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
    Name = "dev-public-subnet-route"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "dev-public-rt" {
  subnet_id = "${aws_subnet.dev-public-subnet.id}"
  route_table_id = "${aws_route_table.dev-public-rt.id}"
}

# Define the security group for dev public subnet
resource "aws_security_group" "dev-sg" {
  name = "dev_sg"
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
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr_dev}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  egress {
     from_port       = 0
     to_port         = 0
     protocol        = "-1"
     cidr_blocks     = ["0.0.0.0/0"]
   }

  vpc_id="${aws_vpc.dev-vpc.id}"

  tags {
    Name = "dev-sg"
  }
}

# Define the security group for dev private subnet
resource "aws_security_group" "sg_dev_private"{
  name = "sg_dev_private"
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
  egress {
     from_port       = 0
     to_port         = 0
     protocol        = "-1"
     cidr_blocks     = ["0.0.0.0/0"]
   }
  vpc_id = "${aws_vpc.dev-vpc.id}"

  tags {
    Name = "sg-dev-private"
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
  map_public_ip_on_launch = true
  tags {
    Name = "prod-public-subnet"
  }
}

# Define  Prod private subnet
resource "aws_subnet" "prod-private-subnet" {
  vpc_id = "${aws_vpc.prod-vpc.id}"
  cidr_block = "${var.private_subnet_cidr_prod}"
  availability_zone = "us-east-1d"

  tags {
    Name = "prod-private-subnet"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "prod-gw" {
  vpc_id = "${aws_vpc.prod-vpc.id}"

  tags {
    Name = "prod-vpc-igw"
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
    Name = "prod-public-subnet-route"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "prod-public-rt" {
  subnet_id = "${aws_subnet.prod-public-subnet.id}"
  route_table_id = "${aws_route_table.prod-public-rt.id}"
}

# Define the security group for public prod subnet
resource "aws_security_group" "prod-sg" {
  name = "prod_sg"
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
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr_prod}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }
   egress {
     from_port       = 0
     to_port         = 0
     protocol        = "-1"
     cidr_blocks     = ["0.0.0.0/0"]
   }

  vpc_id="${aws_vpc.prod-vpc.id}"

  tags {
    Name = "prod-sg"
  }
}

# Define the security group for prod private subnet
resource "aws_security_group" "sg_prod_private"{
  name = "sg_prod_private"
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
    cidr_blocks = ["${var.public_subnet_cidr_prod}"]
  }
    egress {
     from_port       = 0
     to_port         = 0
     protocol        = "-1"
     cidr_blocks     = ["0.0.0.0/0"]
   }

  vpc_id = "${aws_vpc.prod-vpc.id}"

  tags {
    Name = "prod-sg-private"
  }
}
