provider "aws" {
  region = "us-east-1"
}

# Create EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "mykeypair"
  subnet_id     = "subnet-12345678"
  vpc_security_group_ids = ["sg-0123456789abcdef"]
}
