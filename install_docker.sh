# install and configure docker on the ec2 instance
if ! docker --version &> /dev/null
then
  echo "installing docker amazon-linux"
  # sudo yum update -y
  # sudo amazon-linux-extras install docker -y
  # sudo service docker start
  # sudo systemctl enable docker
  echo "installing docker ubuntu"
  sudo apt-get update
  sudo apt-get upgrade
  sudo apt install docker.io
  systemctl start docker
  systemctl enable docker
  docker --version
fi
