provider "aws" {
  access_key = "AKIAJSFJZN6JIZWSJVUA"
  secret_key = "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"
  region     = "us-east-1"
}

resource "aws_key_pair" "access_key" {
  key_name   = "swarm-key"
  public_key = "${file("keys/cluster.pub")}"
}

resource "aws_instance" "master" {
  ami           = "ami-1de3e562"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.access_key.key_name}"
}