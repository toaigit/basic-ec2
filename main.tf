#selecting our region for instance
provider "aws" {
  region = var.region
}

data "template_file" "ps" {
  template = file("userdata.sh")
  vars = {
    s3bucket = var.s3bucket
    domain   = var.domain
  }
}

#creating security group
resource "aws_security_group" "webserver" {
  name        = "allow-ssh-http"
  description = "allow ssh and http traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["171.64.0.0/14","98.207.179.95/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["171.64.0.0/14"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["171.64.0.0/14"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

#creating aws instance
resource "aws_instance" "test" {
  ami               = var.ami
  instance_type     = var.instance_type
  #user_data         = file("userdata.sh")
  user_data         = data.template_file.ps.rendered
  availability_zone = var.zone_2b
  security_groups   = ["${aws_security_group.webserver.name}"]
  key_name          = var.keypair
  iam_instance_profile = var.InstanceProfile
  root_block_device {
    volume_size           = var.boot_volume_size
    volume_type           = "gp2"
    delete_on_termination = true
    tags = {
       "Name" = "boot-disk ${var.hostname}"
       "Environment" = "${var.environment_tag}"
     }
  }

  tags = {
        Name = "${var.hostname}"
  }

}

#creating and attaching ebs volume

resource "aws_ebs_volume" "data-vol" {
 availability_zone = var.zone_2b
 size = var.data_vol_size
 tags = {
        Name = "apps volume ${var.hostname}"
        Server = "${var.hostname}",
        Mounting = "/apps",
        Owner = "appadmin"
        }
 }

resource "aws_ebs_volume" "log-vol" {
 availability_zone = var.zone_2b
 size = var.log_vol_size
 tags = {
        Name = "log volume ${var.hostname}"
        Server = "${var.hostname}",
        Mounting = "/log",
        Owner = "appadmin"
        }
 }
# optional - let userdata to perform this task
#resource "aws_volume_attachment" "datavol" {
# device_name = "/dev/sdc"
# volume_id = "${aws_ebs_volume.data-vol.id}"
# instance_id = "${aws_instance.test.id}"
#}
