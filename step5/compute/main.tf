data "aws_ssm_parameter" "kurata_amazonlinux2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "kurata_amazonlinux2_instance" {
  ami           = data.aws_ssm_parameter.kurata_amazonlinux2_ami.value
  instance_type = var.instance-type
  subnet_id     = var.subnet-id

  tags = {
    Name = "kurata-tf-test-step5"
  }
}
