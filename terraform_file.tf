resource "aws_security_group" "dtcc-gpt-innovation-demo-security-group" {
  name_prefix = "dtcc-gpt-innovation-demo-security-group"

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

  vpc_id = "vpc-0a141f878afe30780"
}

resource "aws_instance" "dtcc-gpt-innovation-demo" {
  ami           = "ami-0a606d8395a538502"
  instance_type = "g4dn.xlarge"
  subnet_id     = "subnet-0c983406b03e8b798"
  vpc_security_group_ids      = [aws_security_group.dtcc-gpt-innovation-demo-security-group.id]
  associate_public_ip_address = true
  iam_instance_profile        = "role_EC2accessViaSSM"

  tags = {
    Name = "dtcc-gpt-innovation-demo"
  }

  user_data = <<-EOF
              #!/bin/bash
              pip install tensorflow transformers streamlit
              EOF
}
``` 

Please note that the template assumes that the necessary IAM role "role_EC2accessViaSSM" is already created. Also, please make sure to provide valid VPC ID and subnet ID