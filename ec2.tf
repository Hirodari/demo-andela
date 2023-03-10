# configured aws provider with proper credentials
# aws configure profile aws configure --profile new_name
# aws list configuration aws configure list [--profile --profile-name]
provider "aws" {
  region  = "us-east-1"
  profile = "hirodaridev"
}


# create default vpc if one does not exit
resource "aws_default_vpc" "default_vpc" {

  tags = {
    Name = "default vpc"
  }
}


# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}


# create default subnet if one does not exit
resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available_zones.names[0]
  tags = {
    Name = "default subnet"
  }
}


# create security group for the ec2 instance
resource "aws_security_group" "ec2_security_group" {
  name        = "docker server SG"
  description = "allow access on ports 80 and 22"
  vpc_id      = aws_default_vpc.default_vpc.id

  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "streamlit access"
    from_port   = 8501
    to_port     = 8501
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "docker server sg"
  }
}


# use data source to get a registered amazon linux 2 ami
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


# launch the ec2 instance
resource "aws_instance" "ec2_instance" {
  ami                    =  data.aws_ami.amazon-linux-2.id
  instance_type          =  "t2.micro"
  subnet_id              =  aws_default_subnet.default_az1.id
  vpc_security_group_ids =  [aws_security_group.ec2_security_group.id]
  key_name               =  "hiro_kp"

  tags = {
    Name = "docker server"
  }
}


# an empty resource block
resource "null_resource" "name" {

  # ssh into the ec2 instance
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/home/fredbitenyo/Desktop/aws-docs/demo-repo/terra_docker/hiro_kp.pem")
    host        = aws_instance.ec2_instance.public_ip
  }

  # copy the password file for your docker hub account
  # from your computer to the ec2 instance
  provisioner "file" {
    source      = "app.py"
    destination = "/home/ec2-user/app.py"
  }

  # copy the dockerfile from your computer to the ec2 instance
  provisioner "file" {
    source      = "Dockerfile"
    destination = "/home/ec2-user/Dockerfile"
  }

  # copy the webapp folder from your computer to the ec2 instance
  provisioner "file" {
    source      = "requirements.txt"
    destination = "/home/ec2-user/requirements.txt"
  }

  # copy the build_docker_image.sh from your computer to the ec2 instance
  provisioner "file" {
    source      = "supermarkt_sales.xlsx"
    destination = "/home/ec2-user/supermarkt_sales.xlsx"
  }

  # copy the build_docker_image.sh from your computer to the ec2 instance
  provisioner "file" {
    source      = "install_build_docker_image.sh"
    destination = "/home/ec2-user/build_docker_image.sh"
  }

  # copy the build_docker_image.sh from your computer to the ec2 instance
  provisioner "file" {
    source      = ".streamlit"
    destination = "/home/ec2-user/.streamlit"
  }

  # set permissions and run the build_docker_image.sh file
  provisioner "remote-exec" {
    inline = [
        "sudo chmod +x /home/ec2-user/install_build_docker_image.sh",
        "bash /home/ec2-user/build_docker_image.sh",

    ]
  }

  # wait for ec2 to be created
  depends_on = [aws_instance.ec2_instance]

}


# print the url of the container
output "container_url" {
  value = join("", ["http://", aws_instance.ec2_instance.public_dns],":8501")
}
