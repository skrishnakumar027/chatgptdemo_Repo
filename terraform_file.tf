resource "aws_security_group" "dtcc-gpt-innovation-demo" {
  name        = "dtcc-gpt-innovation-demo-security-group"
  description = "Security group for DTCC GPT Innovation demo"

  vpc_id      = "vpc-0a141f878afe30780"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8501
    to_port   = 8501
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "dtcc-gpt-innovation-demo" {
  ami = "ami-0a606d8395a538502"
  instance_type = "g4dn.xlarge"
  key_name = "mykeypair"

  subnet_id = "subnet-0c983406b03e8b798"
  vpc_security_group_ids = [aws_security_group.dtcc-gpt-innovation-demo.id]

  associate_public_ip_address = true
  iam_instance_profile = "role_EC2accessViaSSM"

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y python3-pip
              pip3 install tensorflow transformers streamlit
              EOF

  tags = {
    Name = "dtcc-gpt-innovation-demo"
  }
}
``` 

Please note that you will need to have proper authentication set up to use AWS provider in Terraform. Also, make sure to replace the values of `vpc_id`, `subnet_id`, and `iam_instance_profile` with the actual values you have in your AWS account