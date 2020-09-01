variable "name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.nano"
}

variable "key_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }
}

resource "aws_instance" "bastion" {
  count         = 1
  ami           = data.aws_ami.amazon-linux-2
  instance_type = var.instance_type
  key_name      = var.key_name
  monitoring    = false
  subnet_id     = var.subnet_id
  #subnet_id                  = tostring(element(module.vpc.public_subnets, 0))
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
  }

  vpc_security_group_ids = ["${aws_security_group.bastion-sg.id}"]

  lifecycle {
    create_before_destroy = "true"
  }

  tags = merge(
    map("Name", format("%s-bastion", var.name)),
    var.tags
  )
}

resource "aws_security_group" "bastion-sg" {
  name   = "${var.name}-bastion"
  vpc_id = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = var.bastion_cidr
    self        = true
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output bastion_public_ip {
  value = "${aws_instance.bastion[0].public_ip}"
}
