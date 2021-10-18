# Meet Cluster Container
echo -e "================================================================================================"
echo -e "Docker Container List. Choose contanier name for redis cluster"
docker ps -a
echo -e "================================================================================================"
echo Write the container name of 3 nodes to connect the cluster.
read cname1 cname2 cname3

echo -e "================================================================================================"
echo -e "Choose contanier IP, port for redis cluster"
ps -ef | grep redis
echo -e "================================================================================================"
echo Write the IP of the 3 nodes to connect the cluster.
read ip1 ip2 ip3

echo Write the port of the 3 nodes to connect the cluster.
read port1 port2 port3
