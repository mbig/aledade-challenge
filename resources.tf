# Define SSH key pair for  instances
resource "aws_key_pair" "dev-keypair" {
  key_name = "dev-keypair"
  public_key = "${file("${var.key_path}")}"
}

resource "aws_key_pair" "prod-keypair" {
  key_name = "prod-keypair"
  public_key = "${file("${var.key_path}")}"
}



# postgres instance  inside dev private subnet
resource "aws_instance" "dev-postgresdb-instance" {
   ami  = "${var.ami}"
   instance_type = "t2.micro"
   key_name = "${aws_key_pair.dev-keypair.id}"
   subnet_id = "${aws_subnet.dev-public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.dev-sgweb.id}"]
   source_dest_check = false
   #Would  not do this in Prod, this is just for testing. Should be restricted to jumpbox in public subnet
   associate_public_ip_address = true

  tags {
    Name = "dev postgresql instance"
  }
}

# postgres instance  inside prod private subnet
resource "aws_instance" "prod-postgresdb-instance" {
   ami  = "${var.ami}"
   instance_type = "t2.micro"
   key_name = "${aws_key_pair.prod-keypair.id}"
   subnet_id = "${aws_subnet.prod-public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.prod-sgweb.id}"]
   source_dest_check = false
   #Would  not do this in Prod, this is just for testing. Should be restricted to jumpbox in public subnet
   associate_public_ip_address = true

  tags {
    Name = "prod postgresql instance"
  }
}
