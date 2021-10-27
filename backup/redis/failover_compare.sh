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

rm -rf /redis/$tname/work/${TimeForm}_cluster_$tport.txt

# Check the Cluster node
echo -e "================================================================================================"
docker exec $cname redis-cli --cluster check $cip:$cport
echo -e "================================================================================================"


