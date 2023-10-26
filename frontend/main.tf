data "aws_ami" "devops" {
  most_recent = true
  name_regex       = "devops-practice"
  owners = ["973714476881"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.devops.id
  instance_type = "t3.micro"

  tags = {
    Name = "frontend"
  }
 
 provisioner "remote-exec" {
    inline = ["ansible-playbook -i frontend-dev.learnskill.fun, -e ansible_username = centos -e ansible_password = DevOps321 -e role_name = frontend"]

    connection {
      host        = aws_instance.web.public_ip
      type        = "ssh"
      user        = "centos"
      password = "DevOps321"
    }
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "frontend-dev.learnskill.fun"
  type    = "A"
  ttl     = 30
  records = [aws_instance.web.private_ip]
}