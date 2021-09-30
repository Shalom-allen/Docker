#!/bin/bash

# Change the Bind(IP)
echo -e "What do you want to change bind?"
read cbind

sed "s/bind 127.0.0.1 -::1/bind $cbind 127.0.0.1 -::1/g" /root/test_git/default/redis.conf > /root/test_git/result/redis1.conf

# Change the Port
echo -e "What do you want to change the port?"
read cport

sed "s/port 6379/port $cport/g" /root/test_git/result/redis1.conf >> /root/test_git/result/redis_$cport.conf

rm -rf /root/test_git/result/redis1.conf

