#!/bin/bash -xe




# exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
# AUTOUPDATE=false


function platformize(){

#Linux OS detection#
 if hash lsb_release; then
   echo "Ubuntu server OS detected"
   export PLAT="ubuntu"


elif hash yum; then
  echo "Amazon Linux detected"
  export PLAT="amz"

 else
   echo "Unsupported release"
   exit 1

 fi
}


function execute(){

if [ ${PLAT} = "ubuntu" ]; then

  # echo "installing docker ubuntu"
  sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
  sudo apt update -y
  sudo apt-cache policy docker-ce
  sudo apt install docker-ce -y
# Linux post-install
  sudo usermod -aG docker $USER
  sudo systemctl enable docker
  

elif [ ${PLAT} = "amz" ]; then

  echo "installing docker amazon-linux"
  sudo yum update -y
  sudo amazon-linux-extras install docker -y
  echo "making sure the permission is granted"
  sudo usermod -aG docker ${USER}
  sudo systemctl enable docker.service  
  sudo systemctl start docker.service
  echo "running hello-world docker"
  sudo docker run hello-world

else
  echo "Unsupported platform ''${PLAT}''"
fi

}

platformize
execute

