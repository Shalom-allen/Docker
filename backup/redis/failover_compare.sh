TimeForm=`date +"%Y%m%d"`

# Search Docker & Redis Cluster List.
echo -e "Docker Container List."
docker ps -a
echo -e "================================================================================================"
echo -e "Redis Process List"
ps -ef | grep redis
echo -e "================================================================================================"
echo -e "Enter the Docker container information you want to compare.(container, ip, port)"
read tname tip tport

# Compare file to change target.
docker exec $tname redis-cli --cluster check $tip:$tport
docker exec $tname redis-cli --cluster check $tip:$tport > /redis/$tname/work/${TimeForm}_cluster_$tport.txt
echo -e "================================================================================================"
echo -e "#########Tip : first(default set), second(setting of the selected time)#########"
diff -cs /redis/$tname/work/default_cluster_$tport.txt /redis/$tname/work/${TimeForm}_cluster_$tport.txt
echo -e "================================================================================================"

# Perform failover.
echo -e "Please enter the information you wish to failover.(container, ip, port)"
read cname cip cport
docker exec $cname redis-cli -h $cip -p $cport cluster failover

docker exec $cname redis-cli --cluster check $cip:$cport
docker exec $cname redis-cli --cluster check $cip:$cport > /redis/$cname/work/failover_cluster_$cport.txt

# Compare file
echo -e "================================================================================================"
diff -cs /redis/$cname/work/default_cluster_$cport.txt /redis/$cname/work/failover_cluster_$cport.txt
echo -e "================================================================================================"

# Update the default file.
echo -e "Docker Container List."
docker ps -a
echo -e "================================================================================================"
echo -e "Redis Process List"
ps -ef | grep redis
echo -e "================================================================================================"
echo -e "Enter the Docker container information(container)"
read name1 name2 name3
echo -e "Enter the Docker container information(ip)"
read ip1 ip2 ip3
echo -e "Enter the Docker container information(port)"
read port1 port2 port3

docker exec $name1 redis-cli --cluster check $ip1:$port1 > /redis/$name1/work/default_cluster_$port1.txt
docker exec $name2 redis-cli --cluster check $ip2:$port2 > /redis/$name2/work/default_cluster_$port2.txt
docker exec $name3 redis-cli --cluster check $ip3:$port3 > /redis/$name3/work/default_cluster_$port3.txt

