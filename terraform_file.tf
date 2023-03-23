resource "aws_security_group" "demo_sg" {
  name_prefix = "dtcc-gpt-innovation-demo-security-group"

  vpc_id = "vpc-0a141f878afe30780"

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

resource "aws_instance" "demo_instance" {
  ami           = "ami-0a606d8395a538502"
  instance_type = "g4dn.xlarge"
  subnet_id     = "subnet-0c983406b03e8b798"

  vpc_security_group_ids = [aws_security_group.demo_sg.id]

  iam_instance_profile = "role_EC2accessViaSSM"

  tags = {
    Name = "dtcc-gpt-innovation-demo"
  }

  associate_public_ip_address = true

  user_data = <<EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install python3-pip -y
              sudo pip3 install tensorflow transformers streamlit
              EOF
}
``` 

Note: Please replace the values for the VPC ID, subnet ID, IAM role, and other resource attributes as per your requirements