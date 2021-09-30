#! /bin/bash

# Create directory before container creation.
echo -e "What do you want redis instance name?"
read rdir

if [ -d ./redis/$rdir ]
        then echo "This directory has already been created."
        else mkdir -p /redis/$rdir/data /redis/$rdir/log /redis/$rdir/conf /redis/$rdir/backup
fi

# Set the local path and container path.
LOCAL_CONTAINER_DATA="/redis/$rdir/data"
LOCAL_CONTAINER_LOG="/redis/$rdir/log"
LOCAL_CONTAINER_CONF="/redis/$rdir/conf"
LOCAL_CONTAINER_BACKUP="/redis/$rdir/backup"

DOCKER_CONTAINER_DATA="/redis/data"
DOCKER_CONTAINER_LOG="/redis/log"
DOCKER_CONTAINER_CONF="/redis/conf"
DOCKER_CONTAINER_BACKUP="/redis/backup"

# Run Dockerfile for to create docker container.
echo -e "Please write your docker container name."
read cname
echo
echo -e "--------------------------------------------------------------------------------------"
echo -e "#This is your docker image list"
docker image ls
echo -e "--------------------------------------------------------------------------------------"
echo
echo -e "Please choose your container image and tag."
read dimage dtag

echo -e "--------------------------------------------------------------------------------------"
docker run -itd --name $cname -v ${LOCAL_CONTAINER_DATA}:${DOCKER_CONTAINER_DATA} -v ${LOCAL_CONTAINER_LOG}:${DOCKER_CONTAINER_LOG} -v ${LOCAL_CONTAINER_CONF}:${DOCKER_CONTAINER_CONF} -v ${LOCAL_CONTAINER_BACKUP}:${DOCKER_CONTAINER_BACKUP} $dimage:$dtag /bin/bash
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

