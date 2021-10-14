#! /bin/bash
DEFAULTPATH=`pwd`

# Create directory before container creation.
echo -e "What do you want redis instance name?"
read rdir

if [ -e ./redis/$rdir ];then echo check
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
docker run -itd --name $cname --network host -v ${LOCAL_CONTAINER_DATA}:${DOCKER_CONTAINER_DATA} -v ${LOCAL_CONTAINER_LOG}:${DOCKER_CONTAINER_LOG} -v ${LOCAL_CONTAINER_CONF}:${DOCKER_CONTAINER_CONF} -v ${LOCAL_CONTAINER_BACKUP}:${DOCKER_CONTAINER_BACKUP} $dimage:$dtag /bin/bash
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

# Change redis conf
# [Redis_Conf] Change the Bind(IP)
echo -e "What do you want to change bind?"
read cbind

sed "s/bind 127.0.0.1 -::1/bind $cbind 127.0.0.1 -::1/g" /root/test_git/default/redis.conf > /root/test_git/result/redis1.conf

# [Redis_Conf] Change the Port
echo -e "What do you want to change the port?"
read cport

sed "s/port 6379/port $cport/g" /root/test_git/result/redis1.conf >> /root/test_git/result/redis2.conf

rm -rf /root/test_git/result/redis1.conf

# [Redis_Conf] Change the Logfile
sed "s/logfile \/var\/log\/redis_6379.log/logfile \/redis\/log\/redis_$cport.log/g" /root/test_git/result/redis2.conf >> /root/test_git/result/redis3.conf

rm -rf /root/test_git/result/redis2.conf

# [Redis_Conf] Change the Datadir
sed "s/dir \/var\/lib\/redis\/6379/dir \/redis\/data/g" /root/test_git/result/redis3.conf >> /root/test_git/result/redis_$cport.conf

rm -rf /root/test_git/result/redis3.conf

# Move the redis conf
cp $DEFAULTPATH/result/redis_$cport.conf /redis/$rdir/conf

docker exec $cname ./redis_6379 stop
docker exec $cname mv redis_6379 redis_$cport
docker exec $cname sed -i "s/PIDFILE=\/var\/run\/redis_6379.pid/PIDFILE=\/var\/run\/redis_$cport.pid/g" redis_$cport
docker exec $cname sed -i "s/CONF=\"\/etc\/redis\/6379.conf\"/CONF=\"\/redis\/conf\/redis\_$cport.conf\"/g" redis_$cport
docker exec $cname sed -i "s/REDISPORT=\"6379\"/REDISPORT=\"$cport\"/g" redis_$cport

docker exec $cname ./redis_$cport start
