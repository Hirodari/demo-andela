#!/bin/bash

# create a repository to store the docker image in docker hub

# install and configure docker on the ec2 instance
# if ! docker --version &> /dev/null
# then
  # echo "installing docker in amazon linux"
  # sudo yum update -y
  # sudo amazon-linux-extras install docker -y
  # sudo service docker start
  # sudo systemctl enable docker
  # echo "installing docker in Ubuntu"
  # sudo apt-get update
  # sudo apt-get upgrade
  # sudo apt install docker.io
  # systemctl start docker
  # systemctl enable docker
  # docker --version
# fi

# test python code

# build the docker image
sudo docker build -t strealit:1.0 .

# login to your docker hub account
# cat ~/my_password.txt | sudo docker login --username hirodaridevdock --password-stdin

# use the docker tag command to give the image a new name
# sudo docker tag <image-tag> <repository-name>

# push the image to your docker hub repository
# sudo docker push hirodaridevdock/webappdemo:1.0-webapp

# start the container to test the image
echo "running docker run"
sudo docker run -dp 8501:8501 strealit:1.0
