#!/bin/bash
# Author: Fred Bitenyo

# create a repository to store the docker image in docker hub

# install and configure docker on the ec2 instance
if ! docker --version &> /dev/null
then
  if hash yum; then
    echo "Amazon Linux detected"
    echo "installing docker in amazon linux"
    sudo yum update -y
    sudo amazon-linux-extras install docker -y
    sudo service docker start
    sudo systemctl enable docker
  elif hash lsb_release; then
    echo "installing docker in Ubuntu"
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt install docker.io
    systemctl start docker
    systemctl enable docker
    docker --version
  else
   echo "Unsupported operating system"
   exit 1
  fi
fi

# test python code
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>/home/ubuntu/out.log 2>&1
# build the docker image
echo "building a docker image"
sudo docker build -t streamlit:1.0 .

# login to your docker hub account
# cat ~/my_password.txt | sudo docker login --username hirodaridevdock --password-stdin

# use the docker tag command to give the image a new name
# sudo docker tag <image-tag> <repository-name>

# push the image to your docker hub repository
# sudo docker push hirodaridevdock/webappdemo:1.0-webapp

# start the container to test the image
echo "running docker run"
sudo docker run -dp 8501:8501 streamlit:1.0