resource "aws_security_group" "web_server" {
  name        = "web_server_sg"
  description = "web_server_sg"
  vpc_id      = var.vpc_id

  ingress {
    description = "WebServerHTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr, var.myip]
  }
  ingress {
    description = "WebServerHTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr, var.myip]
  }
  ingress {
    description = "WebServerSSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr, var.myip]
  }
   
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS009
  }

  tags = {
    Name        = "mattiafedele-sg"
  }
}