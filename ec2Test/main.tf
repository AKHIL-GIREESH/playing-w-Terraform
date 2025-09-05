resource "aws_instance" "firstEC2" {
  ami                    = "ami-0e35ddab05955cf57"
  instance_type          = "t2.micro"
  user_data              = <<-EOF
                            #!/bin/bash
                            sudo touch /var/www/html/index.html
                            sudo echo "Hello, world!" > /var/www/html/index.html
                            EOF
  key_name               = aws_key_pair.rsaa.id
  vpc_security_group_ids = [aws_security_group.ssh-access.id]
  tags = {
    Name        = "firstEC2TF"
    Description = "First ever EC2 using TF"
  }
}

resource "aws_key_pair" "rsaa" {
  public_key = file("/Users/akhilgireesh/.ssh/id_rsa.pub")
}

resource "aws_security_group" "ssh-access" {
  name        = "ssh-access"
  description = "To allow ssh access from the internet"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "publicIp" {
  value = aws_instance.firstEC2.public_ip
}
