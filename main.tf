
resource "aws_instance" "gitlab" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.xlarge"
  key_name      = "nosaj"
  vpc_security_group_ids = [data.aws_security_group.gitlab.id]
  user_data       = file("userdata.tpl")

  tags = {
    Name = "GitLab Server - Ubuntu"
  }

}


data "aws_security_group" "gitlab" {
  id = "sg-05e46e2ffd3261526"
}


resource "aws_route53_record" "gitlab" {
  name = "gitlab.quickcloudsetup.com"
  type = "A"
  ttl = 60
  zone_id = "Z00619834POAGICFNWEM"
  records = [
    "${aws_instance.gitlab.public_ip}"
  ]
}

variable "ebs_volume_size" {
  default = "16"
}

resource "aws_ebs_volume" "gitlab" {
  availability_zone = "us-east-1a" # to replace with the availability zone of your existing volume
  size              = var.ebs_volume_size # Increase the size to 250GB
}

output "gitlab_public_ip" {
  value = aws_instance.gitlab.public_ip
}
