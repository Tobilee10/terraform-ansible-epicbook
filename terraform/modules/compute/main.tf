resource "aws_key_pair" "eb-deployer" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}


resource "aws_instance" "eb_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = aws_key_pair.eb-deployer.key_name
  associate_public_ip_address = true
  
  tags = {
    Name = "eb-instance-prod"
  }
}

