resource "aws_security_group" "dtcc-gpt-innovation-demo-security-group" {
  name_prefix = "dtcc-gpt-innovation-demo-security-group"
  vpc_id      = "vpc-0a141f878afe30780" 

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
}

resource "aws_instance" "dtcc-gpt-innovation-demo" {
  ami                    = "ami-0a606d8395a538502"
  instance_type          = "g4dn.xlarge"
  vpc_id                 = "vpc-0a141f878afe30780"
  subnet_id              = "subnet-0c983406b03e8b798"
  associate_public_ip_address = true
  iam_instance_profile = "role_EC2accessViaSSM"
  key_name = "ssh-key"
  security_group_ids     = [aws_security_group.dtcc-gpt-innovation-demo-security-group.id]
  user_data = <<-EOF
              #!/bin/bash
              pip install tensorflow transformers streamlit
              EOF

  tags = {
    Name = "dtcc-gpt-innovation-demo"
  }
}
