#!/bin/bash

# [Redis_Conf] Set the container path.
DOCKER_CONTAINER_DATA="/redis/data"
DOCKER_CONTAINER_LOG="/redis/log"
DOCKER_CONTAINER_CONF="/redis/conf"

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

# [Redis_Conf] Change the cluster
sed "s/^# cluster-enabled yes/cluster-enabled yes/g" /root/test_git/result/redis4.conf >> /root/test_git/result/redis5.conf

rm -rf /root/test_git/result/redis4.conf

sed "s/^# cluster-config-file nodes-6379.conf/cluster-config-file nodes-$cport.conf/g" /root/test_git/result/redis5.conf >> /root/test_git/result/redis6.conf

rm -rf /root/test_git/result/redis5.conf

sed "s/^# cluster-node-timeout 15000/cluster-node-timeout 3000/g" /root/test_git/result/redis6.conf >> /root/test_git/result/redis7.conf

rm -rf /root/test_git/result/redis6.conf

sed "s/^# cluster-replica-validity-factor 10/cluster-replica-validity-factor 0/g" /root/test_git/result/redis7.conf >> /root/test_git/result/redis_$cport.conf

rm -rf /root/test_git/result/redis7.conf

