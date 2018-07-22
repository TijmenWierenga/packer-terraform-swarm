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
  key_name      = "${aws_key_pair.access_key.key_name}"
  count         = 2
}