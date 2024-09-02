resource "aws_instance" "test_t2_micro" {
  # count = 1 # define the number of instances
  # ami                    = "ami-0a0c8eebcdd6dcbd0" # ubuntu arm64 
  ami                  = "ami-0c7217cdde317cfec" # Ubuntu amd64 (x86_64)
  instance_type          = "t2.micro" # free tier
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  user_data              = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y apache2
    sudo systemctl start apache2
    sudo systemctl enable apache2
    sudo bash -c 'cat > /var/www/html/index.html' <<EOF_HTML
    <!DOCTYPE html>
    <html>
    <head>
    <style>
      body {
        background-color: #A1B0FF;
        text-align: center;
      }
    </style>
    </head>
    <body>
      <h1>Hello, Team.</h1>
      <h1>Welcome to my Apache server!</h1>
    </body>
    </html>
    EOF_HTML
  EOF

  tags = {
    Name = "Test instances for the lesson"
  }
}

resource "random_pet" "sg" {}

resource "aws_security_group" "web-sg" {
  name = "${random_pet.sg.id}-sg"
  ingress {
    from_port   = 22 # ssh access port (ssh)
    to_port     = 9001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "ping"
  }
  egress {
    from_port   = 22
    to_port     = 9001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}