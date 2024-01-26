data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*.*-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.web_server.id]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.web_server.name

  user_data = file("./data/userdata.sh")

  tags = {
    Name = "mattiafedele"
    Type = "webserver"
  }
}