#!/bin/bash

<<<<<<< HEAD
# [Redis_Conf] Set the container path.
=======
# Set the container path.
>>>>>>> d4a3b9f8c5238c3476107eed72dd4d8ceaebd75f
DOCKER_CONTAINER_DATA="/redis/data"
DOCKER_CONTAINER_LOG="/redis/log"
DOCKER_CONTAINER_CONF="/redis/conf"

<<<<<<< HEAD
# [Redis_Conf] Change the Bind(IP)
=======
# Change the Bind(IP)
>>>>>>> d4a3b9f8c5238c3476107eed72dd4d8ceaebd75f
echo -e "What do you want to change bind?"
read cbind

sed "s/bind 127.0.0.1 -::1/bind $cbind 127.0.0.1 -::1/g" /root/test_git/default/redis.conf > /root/test_git/result/redis1.conf

<<<<<<< HEAD
# [Redis_Conf] Change the Port
=======
# Change the Port
>>>>>>> d4a3b9f8c5238c3476107eed72dd4d8ceaebd75f
echo -e "What do you want to change the port?"
read cport

sed "s/port 6379/port $cport/g" /root/test_git/result/redis1.conf >> /root/test_git/result/redis2.conf

rm -rf /root/test_git/result/redis1.conf

<<<<<<< HEAD
# [Redis_Conf] Change the Logfile
sed "s/logfile \/var\/log\/redis_6379.log/logfile \/redis\/log\/redis_$cport.log/g" /root/test_git/result/redis2.conf >> /root/test_git/result/redis3.conf

rm -rf /root/test_git/result/redis2.conf

# [Redis_Conf] Change the Datadir
=======
# Change the Logfile
sed "s/logfile \/var\/log\/redis_6379.log/logfile \/redis\/log/g" /root/test_git/result/redis2.conf >> /root/test_git/result/redis3.conf

rm -rf /root/test_git/result/redis2.conf

# Change the Datadir
>>>>>>> d4a3b9f8c5238c3476107eed72dd4d8ceaebd75f
sed "s/dir \/var\/lib\/redis\/6379/dir \/redis\/data/g" /root/test_git/result/redis3.conf >> /root/test_git/result/redis_$cport.conf

rm -rf /root/test_git/result/redis3.conf
