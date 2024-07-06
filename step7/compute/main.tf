data "aws_ssm_parameter" "kurata_amazonlinux2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "kurata_amazonlinux2_instance" {
  ami                    = data.aws_ssm_parameter.kurata_amazonlinux2_ami.value
  instance_type          = var.instance-type
  subnet_id              = var.subnet-id
  vpc_security_group_ids = [aws_security_group.kurata_tf_test_sg.id]

  root_block_device {
    encrypted = var.app == "front" ? true : false
  }

  tags = {
    Name = "${var.pj}-${var.app}"
  }
}

resource "aws_security_group" "kurata_tf_test_sg" {
  name        = "${var.pj}-${var.app}-ec2-sg"
  description = "${var.pj}-${var.app} ec2 sg"
  vpc_id      = var.vpc-id

  dynamic "ingress" {
    for_each = toset(var.allow-tcp-ports)
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "TCP"
      cidr_blocks = [var.allow-ingress-cidr]
    }
  }

  tags = {
    Name = "${var.pj}-${var.app}"
  }
}

resource "aws_s3_bucket" "kurata_tf_test_s3" {
  count = var.app == "back" ? 1 : 0

  bucket = "${var.pj}-${var.app}-bucket"

  tags = {
    Name = "${var.pj}-${var.app}"
  }
}
