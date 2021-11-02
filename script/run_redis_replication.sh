#! /bin/bash
DEFAULTPATH=`pwd`

# Create directory before container creation.
echo -e "What do you want redis instance name?"
read rdir

if [ -e ./redis/$rdir ];then echo check
	else mkdir -p /redis/$rdir/data /redis/$rdir/log /redis/$rdir/conf /redis/$rdir/work
fi

# Set the local path and container path.
LOCAL_CONTAINER_DATA="/redis/$rdir/data"
LOCAL_CONTAINER_LOG="/redis/$rdir/log"
LOCAL_CONTAINER_CONF="/redis/$rdir/conf"
LOCAL_CONTAINER_BACKUP="/redis/$rdir/work"

DOCKER_CONTAINER_DATA="/redis/data"
DOCKER_CONTAINER_LOG="/redis/log"
DOCKER_CONTAINER_CONF="/redis/conf"
DOCKER_CONTAINER_BACKUP="/redis/work"

# Run Dockerfile for to create docker container.
echo
echo -e "--------------------------------------------------------------------------------------"
echo -e "#This is your docker image list"
docker image ls
echo -e "--------------------------------------------------------------------------------------"
echo
echo -e "Please choose your container image and tag."
read dimage dtag
echo
echo -e "--------------------------------------------------------------------------------------"
docker run -itd --name $rdir --network host -v ${LOCAL_CONTAINER_DATA}:${DOCKER_CONTAINER_DATA} -v ${LOCAL_CONTAINER_LOG}:${DOCKER_CONTAINER_LOG} -v ${LOCAL_CONTAINER_CONF}:${DOCKER_CONTAINER_CONF} -v ${LOCAL_CONTAINER_BACKUP}:${DOCKER_CONTAINER_BACKUP} $dimage:$dtag /bin/bash
echo -e "--------------------------------------------------------------------------------------"
docker ps -a
echo -e "--------------------------------------------------------------------------------------"

# Check the Docker container Redis instance start and status.
echo -e "--------------------------------------------------------------------------------------"
echo Start docker redis instance.
docker exec $rdir ./redis_6379 start
echo -e "--------------------------------------------------------------------------------------"
echo -e "Show $rdir process list for redis."
docker exec $rdir ps -ef | grep redis 
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
sed "s/dir \/var\/lib\/redis\/6379/dir \/redis\/data/g" /root/test_git/result/redis3.conf >> /root/test_git/result/redis4.conf

rm -rf /root/test_git/result/redis3.conf

# [Redis_Conf] setting for Replication
echo -e "Please write down the master IP and master port you want to designate."
read masterip masterport

sed "s/^# replicaof <masterip> <masterport>/replicaof $masterip $masterport/g" /root/test_git/result/redis4.conf >> /root/test_git/result/redis5.conf

rm -rf /root/test_git/result/redis4.conf

sed "s/pidfile \/var\/run\/redis_6379.pid/pidfile \/var\/run\/redis_$cport.pid/g" /root/test_git/result/redis5.conf >> /root/test_git/result/redis_$cport.conf

rm -rf /root/test_git/result/redis5.conf

# Move the redis conf
cp $DEFAULTPATH/result/redis_$cport.conf /redis/$rdir/conf

docker exec $rdir ./redis_6379 stop
docker exec $rdir mv redis_6379 redis_$cport
docker exec $rdir sed -i "s/PIDFILE=\/var\/run\/redis_6379.pid/PIDFILE=\/var\/run\/redis_$cport.pid/g" redis_$cport
docker exec $rdir sed -i "s/CONF=\"\/etc\/redis\/6379.conf\"/CONF=\"\/redis\/conf\/redis\_$cport.conf\"/g" redis_$cport
docker exec $rdir sed -i "s/REDISPORT=\"6379\"/REDISPORT=\"$cport\"/g" redis_$cport

docker exec $rdir ./redis_$cport start

ps -ef | grep redis

# Check the redis slave status
docker exec $rdir redis-cli -h $cbind -p $cport info replication

