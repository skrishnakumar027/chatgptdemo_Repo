variable "vpc_id" {
  default = "vpc-0a141f878afe30780"
}

variable "subnet_id" {
  default = "subnet-0c983406b03e8b798"
}

resource "aws_security_group" "dtcc-gpt-innovation-demo-security-group" {
  name_prefix = "dtcc-gpt-innovation-demo-security-group"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port = 8501
    to_port   = 8501
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  vpc_id = var.vpc_id
}

data "aws_ami" "tf-ami" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["Deep Learning AMI (Amazon Linux 2) Version 45.0"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }
}

resource "aws_instance" "dtcc-gpt-innovation-demo" {
  ami               = data.aws_ami.tf-ami.id
  instance_type     = "g4dn.xlarge"
  associate_public_ip_address = true
  subnet_id         = var.subnet_id
  vpc_security_group_ids = [aws_security_group.dtcc-gpt-innovation-demo-security-group.id]
  iam_instance_profile = "role_EC2accessViaSSM"
  user_data         = <<-EOC
                      #!/bin/bash
                      pip install tensorflow transformers streamlit
                      EOC

  tags = {
    Name = "dtcc-gpt-innovation-demo"
  }
