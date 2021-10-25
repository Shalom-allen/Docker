TimeForm=`date +"%Y%m%d"`

echo -e "================================================================================================"
echo -e "Docker Container List."
docker ps -a
echo -e "================================================================================================"
echo -e "Redis Process List"
ps -ef | grep redis
echo -e "================================================================================================"

echo -e "Enter the Docker container information you want to compare.(container, ip, port)"
read cname cip cport
docker exec $cname redis-cli --cluster check $cip:$cport > /redis/$cname/data/${TimeForm}_cluster_$cport.txt
echo -e "================================================================================================"
echo -e "#########Tip : first(default set), second(setting of the selected time)#########"

diff -ci /redis/$cname/data/redis_cluster_$cport.txt /redis/$cname/data/${TimeForm}_cluster_$cport.txt 
echo -e "================================================================================================"

echo -e "Please enter the information of the node you want to failover.(container, ip, port)"
read name ip port
docker exec $name redis-cli -h $ip -p $port cluster failover

docker exec $name redis-cli --cluster check $ip:$port

echo -e "================================================================================================"
diff -ci /redis/$cname/data/redis_cluster_$cport.txt /redis/$cname/data/${TimeForm}_cluster_$cport.txt
echo -e "================================================================================================"

