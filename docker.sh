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

# Move the demo static html file to user directory
cp -pr ./site ~/site-content

echo "Moved static index.html file from working directory to user directory"

# Next, we create containers from the respective images, 
# making sure to detatch in interactive mode, 

docker run -dit --name kibana kibana:6.4.2 /bin/bash 
docker run -dit --rm -p 8080:80 --name nginx -v ~/site-content:/usr/share/nginx/html nginx
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

echo "Connected all containers to entNet"

# Pipe the network info to stdout
docker network inspect entNet

# Verify that each container can ping the other two instances
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

# There should be a total of 6 outputs from previous command
# Next verify that the kibana container can access the static web page on nginx
docker exec kibana curl nginx

echo "Program complete"
#EOF
