#! /bin/bash

# Create Docker for redis image.
echo -e "Please choose docker image name and tag name."
read dimage dtag
echo -e "Where is dockerfile location?"
read dlocate
docker build -t $dimage:$dtag $dlocate

# Create directory before container creation.
echo -e "What do you want redis instance name?"
read rdir
mkdir -p /redis/$rdir/data
mkdir -p /redis/$rdir/log
mkdir -p /redis/$rdir/conf
mkdir -p /redis/$rdir/backup

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
echo -e "Where did you want to connet container directory to local directory for data directory?"
read dlocal dcontainer
echo -e "Where did you want to connet container directory to local directory for log directory?"
read llocal lcontainer
echo -e "Where did you want to connet container directory to local directory for conf directory?"
read clocal ccontainer
echo -e "Where did you want to connet container directory to local directory for backup directory?"
read blocal bcontainer

echo -e "--------------------------------------------------------------------------------------"
docker run -itd --name $cname -v $dlocal:$dcontainer -v $llocal:$lcontainer -v $clocal:$ccontainer -v $blocal:$bcontainer $dimage:$dtag /bin/bash
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

