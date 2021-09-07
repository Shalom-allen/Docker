#! /bin/bash

# Run Dockerfile for to create docker image.
echo -e "Please write your docker container name."
read cname
echo
echo -e "--------------------------------------------------------------------------------------"
echo -e "#This is your docker image list"
docker image ls 
echo -e "--------------------------------------------------------------------------------------"
echo
echo -e "Please choose your container image and tage."
read dimage dtage
echo -e "--------------------------------------------------------------------------------------"
docker run -itd --name $cname $dimage:$dtage /bin/bash
echo -e "--------------------------------------------------------------------------------------"
docker ps -a
echo -e "--------------------------------------------------------------------------------------"

# Check the Docker container Redis instance start and status.
echo -e "--------------------------------------------------------------------------------------"
echo Start docker redis instance.
docker exec $cname ./redis_6379 start
echo -e "--------------------------------------------------------------------------------------"
echo -e "Show $cname process list for redis."
docker exec $cname ps -ef | grep redis 
echo -e "--------------------------------------------------------------------------------------"

