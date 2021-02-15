#!/bin/bash
declare -a instances=("kibana" "nginx" "mysql")

for i in "${instances[@]}"
do
	docker rm -f "$i"
done
docker network rm entNet
rm -rf ~/site-content
#EOF