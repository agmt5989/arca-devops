#!/bin/bash

# This script provisions 3 docker containers

echo "This is a script that automatically provisions 3 docker containers"
echo "The containers will respectively contain kibana, nginx and mysql instances"

# The docker commands

docker pull kibana:6.4.2
docker pull nginx
docker pull mysql

echo "Successfully pulled container images from the docker public registry"

# Next, we create containers from the respective images, 
# making sure to detatch in interactive mode, 

docker run -dit --name kibana kibana:6.4.2 /bin/bash 
docker run -dit --name nginx nginx /bin/bash
docker run -dit --name mysql mysql /bin/bash

# Installing iputils-ping as the case applies.
# kibana comes with ping installed
docker exec nginx bash -c "apt update ; apt -y install iputils-ping"
docker exec mysql bash -c "apt update ; apt -y install iputils-ping"

