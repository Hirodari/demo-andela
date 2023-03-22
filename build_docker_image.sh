#!/bin/bash

# Author: Fred Bitenyo

# create a repository to store the docker image in docker hub

# install and configure docker on the ec2 instance

# exec 3>&1 4>&2
# trap 'exec 2>&4 1>&3' 0 1 2 3
# exec 1>/home/ubuntu/out.log 2>&1
# build the docker image
echo "building a docker image"
docker build -t streamlit:1.0 .

# login to your docker hub account
# cat ~/my_password.txt | sudo docker login --username hirodaridevdock --password-stdin

# use the docker tag command to give the image a new name
# sudo docker tag <image-tag> <repository-name>

# push the image to your docker hub repository
# sudo docker push hirodaridevdock/webappdemo:1.0-webapp

# start the container to test the image
echo "running docker run"
docker run -dp 8501:8501 streamlit:1.0
echo "Thank you."