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
   vpc_security_group_ids = ["${aws_security_group.dev-sg.id}"]

   provisioner "remote-exec" {
      inline = ["sudo yum update -y"]

      connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = "${file("${var.key_path_priv}")}"
      }
    }

    provisioner "local-exec" {
      command = "AWS_ACCESS_KEY_ID=${var.AWS_ACCESS_KEY} AWS_SECRET_ACCESS_KEY=${var.AWS_SECRET_KEY}  ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ec2-user --private-key '${file("${var.key_path_priv}")}' -i ec2.py deploy_postgresql_dev.yml"


    }


  tags {
    Name = "dev-postgresql-instance"
    env = "dev"
  }
}




# Prod db instance
resource "aws_instance" "prod-postgresdb-instance" {
   ami  = "${var.ami}"
   instance_type = "t2.micro"
   key_name = "${aws_key_pair.prod-keypair.id}"
   subnet_id = "${aws_subnet.prod-public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.prod-sg.id}"]

   provisioner "remote-exec" {
      inline = ["sudo yum update -y"]

      connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = "${file("${var.key_path_priv}")}"
      }
    }

    provisioner "local-exec" {
      
      command = "AWS_ACCESS_KEY_ID=${var.AWS_ACCESS_KEY} AWS_SECRET_ACCESS_KEY=${var.AWS_SECRET_KEY} ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ec2-user --private-key '${file("${var.key_path_priv}")}' -i ec2.py deploy_postgresql_prod.yml"


    }

  tags {
    Name = "prod-postgresql-instance"
    env  = "prod"
  }
}
