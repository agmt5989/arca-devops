#!/bin/bash

# This script provisions 3 docker containers

echo "This is a script that automatically provisions 3 docker containers"
echo "The containers will respectively contain kibana, nginx and mysql instances"

# The docker commands
echo "Pulling the three images from the docker registry"

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

# Going forwaard, we'll use the container names in an array
declare -a instances=("kibana" "nginx" "mysql")

# Basic docker networking
docker network create entNet # short for enterprise network

## now loop through the above array
for i in "${instances[@]}"
do
   docker network connect entNet "$i"
done

# Pipe the network info to stdout
docker network inspect entNet

# Verify that each container can ping all instances
for i in "${!instances[@]}"
do
	pingers=("${instances[@]}")
	unset pingers[$i]

	for j in "${pingers[@]}"
	do
		echo -e "\r\n\r\n===${instances[$i]} pinging $j . . . ==="
		docker exec "${instances[$i]}" ping -c 2 "$j"
	done
done

# There should be a total of 9 (not 6) outputs from previous command
echo "Program complete"
