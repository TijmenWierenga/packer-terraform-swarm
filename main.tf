provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_key_pair" "access_key" {
  key_name   = "swarm-key"
  public_key = "${file("keys/cluster.pub")}"
}

resource "aws_instance" "master" {
  ami           = "ami-1de3e562"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.access_key.key_name}",
  vpc_security_group_ids = [
    "${aws_security_group.docker.id}"
  ]

  connection {
     user = "ubuntu"
     private_key = "${file("keys/cluster")}"
   }

  provisioner "remote-exec" {
    inline = [
      "docker swarm init --advertise-addr ${self.private_ip}"
    ]
  }

  provisioner "local-exec" {
    command = "ssh -o 'StrictHostKeyChecking no' -i 'keys/cluster' ubuntu@${self.public_ip} 'docker swarm join-token manager -q' >> artifacts/manager-token.txt"
  }
}

resource "aws_instance" "manager" {
  ami           = "ami-1de3e562"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.access_key.key_name}",
  vpc_security_group_ids = [
    "${aws_security_group.docker.id}"
  ]
  count         = 2
  depends_on = ["aws_instance.master"]

  connection {
    user = "ubuntu"
    private_key = "${file("keys/cluster")}"
  }

  provisioner "file" {
    source = "artifacts/manager-token.txt"
    destination = "/var/tmp/manager-token.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "docker swarm join --token $(cat /var/tmp/manager-token.txt) --advertise-addr ${self.private_ip}:2377",
      "rm /var/tmp/manager-token.txt"
    ]
  }
}

resource "aws_security_group" "docker" {
  name = "docker"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 2377
    to_port   = 2377
    protocol  = "tcp"
    self      = true
  }
  ingress {
    from_port = 7946
    to_port   = 7946
    protocol  = "tcp"
    self      = true
  }
  ingress {
    from_port = 7946
    to_port   = 7946
    protocol  = "udp"
    self      = true
  }
  ingress {
    from_port = 4789
    to_port   = 4789
    protocol  = "tcp"
    self      = true
  }
  ingress {
    from_port = 4789
    to_port   = 4789
    protocol  = "udp"
    self      = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "master_ip" {
  value = "${aws_instance.master.public_ip}"
}

output "manager_ips" {
  value = "${aws_instance.manager.*.public_ip}"
}