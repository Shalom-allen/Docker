# Meet Cluster Container
echo Write the container name of 3 nodes to connect the cluster.
read cname1 cname2 cname3

echo Write the IP of the 3 nodes to connect the cluster.
read ip1 ip2 ip3 

echo Write the port of the 3 nodes to connect the cluster.
read port1 port2 port3

docker exec $cname1 redis-cli -h $ip1 -p $port1 cluster meet $ip1 $port1
docker exec $cname1 redis-cli -h $ip2 -p $port2 cluster meet $ip1 $port1
docker exec $cname1 redis-cli -h $ip3 -p $port3 cluster meet $ip1 $port1

# Socket
echo -e "Sockets are automatically distributed in increments of 5461."
docker exec $cname1 redis-cli -h $ip1 -p $port1 cluster addslots {0..5461}
docker exec $cname1 redis-cli -h $ip2 -p $port2 cluster addslots {5462..10922}
docker exec $cname1 redis-cli -h $ip3 -p $port3 cluster addslots {10923..16384}

# Check the Redis Cluster
docker exec $cname1 redis-cli --cluster check $ip1:$port1
