data "aws_ami" "example" {
 # executable_users = ["self"]
  most_recent      = true
  name_regex       = "DevOps-Practice"
  owners           = ["973714476881"]
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow ssh inbound traffic"

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow_All"
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.example.id
  instance_type = "t3.micro"
  security_groups = [resource.aws_security_group.allow_all.name]
  #iam_instance_profile = "arn:aws:iam::322657627157:role/AccessSSMParameters"
  iam_instance_profile = "${aws_iam_instance_profile.SSMParam_profile.name}"

  tags = {
    Name = "frontend"
  }
 
}

resource "null_resource" "runansible" {
  depends_on = [aws_instance.web, aws_route53_record.www]
  provisioner "remote-exec" {
    inline = [
      "sudo labauto ansible",
      "ansible-pull -i localhost, -U https://github.com/MahendranJayachandra/roboshop-ansible roboshop.yml -e role_name='frontend'"
      ]

    connection {
      host        = resource.aws_instance.web.public_ip
      type        = "ssh"
      user        = "centos"
      password = "DevOps321"
    }
  }
}

resource "aws_route53_record" "www" {
  zone_id = "Z0297172FL3FT10HX2F2"
  name    = "frontend-dev.learnskill.fun"
  type    = "A"
  ttl     = 30
  records = [aws_instance.web.private_ip]
}

resource "aws_iam_instance_profile" "SSMParam_profile" {
  name = "attachrole"
  role = "${data.aws_iam_role.example.name}"
}

data "aws_iam_role" "example" {
  name = "workstationrole"
}