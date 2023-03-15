resource "aws_security_group" "example" {
  name        = "dtcc-gpt-demo-innovation-security-group"
  description = "Allow incoming traffic on ports 22 and 8501"
  vpc_id      = "vpc-0a141f878afe30780"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8501
    to_port     = 8501
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0842866abbdf82e24"
  instance_type = "g4dn.xlarge"
  vpc_security_group_ids = [aws_security_group.example.id]
  subnet_id     = "subnet-0c983406b03e8b798"
  associate_public_ip_address = true
  iam_instance_profile = "role_EC2accessViaSSM"
  tags = {
    Name = "dtcc-gpt-demo-innovation"
  }

  user_data = <<EOF
#!/bin/bash

# activate the pre-built pytorch environment
source activate pytorch

# install libraries "transformers" and "streamlit" via pip
pip install transformers streamlit
EOF
}
