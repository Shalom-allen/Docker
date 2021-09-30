#!/bin/bash

# Set the container path.
DOCKER_CONTAINER_DATA="/redis/data"
DOCKER_CONTAINER_LOG="/redis/log"
DOCKER_CONTAINER_CONF="/redis/conf"

# Change the Bind(IP)
echo -e "What do you want to change bind?"
read cbind

sed "s/bind 127.0.0.1 -::1/bind $cbind 127.0.0.1 -::1/g" /root/test_git/default/redis.conf > /root/test_git/result/redis1.conf

# Change the Port
echo -e "What do you want to change the port?"
read cport

sed "s/port 6379/port $cport/g" /root/test_git/result/redis1.conf >> /root/test_git/result/redis2.conf

rm -rf /root/test_git/result/redis1.conf

# Change the Logfile
sed "s/logfile \/var\/log\/redis_6379.log/logfile \/redis\/log/g" /root/test_git/result/redis2.conf >> /root/test_git/result/redis3.conf

rm -rf /root/test_git/result/redis2.conf

# Change the Datadir
sed "s/dir \/var\/lib\/redis\/6379/dir \/redis\/data/g" /root/test_git/result/redis3.conf >> /root/test_git/result/redis_$cport.conf

rm -rf /root/test_git/result/redis3.conf
