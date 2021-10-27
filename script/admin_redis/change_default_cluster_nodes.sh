# Update the default file.
echo -e "Docker Container List."
docker ps -a
echo -e "================================================================================================"
echo -e "Redis Process List"
ps -ef | grep redis
echo -e "================================================================================================"
echo -e "Enter the Docker container information(container)"
read dname1 dname2 dname3
echo -e "Enter the Docker container information(ip)"
read dip1 dip2 dip3
echo -e "Enter the Docker container information(port)"
read dport1 dport2 dport3

docker exec $dname1 redis-cli --cluster check $dip1:$dport1 > /redis/$dname1/work/default_cluster_$dport1.txt
docker exec $dname2 redis-cli --cluster check $dip2:$dport2 > /redis/$dname2/work/default_cluster_$dport2.txt
docker exec $dname3 redis-cli --cluster check $dip3:$dport3 > /redis/$dname3/work/default_cluster_$dport3.txt

