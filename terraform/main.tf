terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.32.1"
    }
  }
}

provider "aws" {
  region = "eu-west-3"
}

data "aws_ssm_parameter" "amazon_linux_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_key_pair" "devops_key" {
  key_name   = "devops-key-terraform"
  public_key = file("/Users/hamza/devops-project/devops-key.pub")
}

resource "aws_instance" "master" {
  ami           = data.aws_ssm_parameter.amazon_linux_ami.value
  instance_type = "t3.micro"
  key_name      = aws_key_pair.devops_key.key_name

  tags = {
    Name = "k8s-master"
  }
}

resource "aws_instance" "worker" {
  ami           = data.aws_ssm_parameter.amazon_linux_ami.value
  instance_type = "t3.micro"
  key_name      = aws_key_pair.devops_key.key_name

  tags = {
    Name = "k8s-worker"
  }
}