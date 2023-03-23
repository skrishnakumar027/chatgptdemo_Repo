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
  vpc_security_group_ids = [aws_security_group.dtcc-gpt-innovation-demo-security-group.id]
  associate_public_ip_address = true
  iam_instance_profile = "role_EC2accessViaSSM"

  user_data = <<-EOF
              #!/bin/bash
              pip install tensorflow transformers streamlit
              EOF

  tags = {
    Name = "dtcc-gpt-innovation-demo"
  }
}
```
Note that I used the `resource` block to create the security group and the EC2 instance. I also used the `ami` and `instance_type` arguments to specify the desired EC2 instance, and the `subnet_id` argument to place it in a specific subnet. The `vpc_security_group_ids` argument is used to attach the security group to the instance, and `associate_public_ip_address` is used to assign a public IP. I also added a `user_data` block to run some shell commands when the instance starts, installing the required packages. Lastly, I added a tag to the instance for identification