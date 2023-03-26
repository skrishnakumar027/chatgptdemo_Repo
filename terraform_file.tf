resource "aws_security_group" "dtcc-gpt-innovation-demo-security-group" {
  name        = "dtcc-gpt-innovation-demo-security-group"
  description = "Allow inbound traffic on ports 22 and 8501 and allow all outbound traffic"

  vpc_id = "vpc-0a141f878afe30780"

  ingress {
    description = "allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow streamlit"
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

resource "aws_instance" "dtcc-gpt-innovation-demo-instance" {
  ami           = "ami-0a606d8395a538502"
  instance_type = "g4dn.xlarge"
  subnet_id     = "subnet-0c983406b03e8b798"

  tags = {
    Name = "dtcc-gpt-innovation-demo"
  }

  vpc_security_group_ids = [
    aws_security_group.dtcc-gpt-innovation-demo-security-group.id
  ]

  iam_instance_profile = "role_EC2accessViaSSM"

  user_data = <<EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install python3-pip -y
              sudo pip3 install tensorflow transformers streamlit
              EOF

  associate_public_ip_address = true
}
