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
docker exec $tname redis-cli --cluster check $tip:$tport > /redis/$tname/work/${TimeForm}_cluster_$tport.txt
cat /redis/$tname/work/${TimeForm}_cluster_$tport.txt | cut -d '>' -f 1 | cut -d '[' -f 1 > /redis/$tname/work/${TimeForm}_cluster_$tport\_1.txt
rm -rf /redis/$tname/work/${TimeForm}_cluster_$tport.txt
sed '1,6d' /redis/$tname/work/${TimeForm}_cluster_$tport\_1.txt > /redis/$tname/work/${TimeForm}_cluster_$tport\_2.txt
rm -rf /redis/$tname/work/${TimeForm}_cluster_$tport\_1.txt
sed -i '/1 additional/d' /redis/$tname/work/${TimeForm}_cluster_$tport\_2.txt
sed -i '/slots:/d' /redis/$tname/work/${TimeForm}_cluster_$tport\_2.txt
sed -i '/replicates/d' /redis/$tname/work/${TimeForm}_cluster_$tport\_2.txt
sort /redis/$tname/work/${TimeForm}_cluster_$tport\_2.txt | sort -k 3 > /redis/$tname/work/${TimeForm}_cluster_$tport\_3.txt
rm -rf /redis/$tname/work/${TimeForm}_cluster_$tport\_2.txt
sed '1,4d' /redis/$tname/work/${TimeForm}_cluster_$tport\_3.txt > /redis/$tname/work/cluster_node_status_before.txt
rm -rf /redis/$tname/work/${TimeForm}_cluster_$tport\_3.txt

echo -e "================================================================================================"
echo -e "#########Tip : first(default set), second(setting of the selected time)#########"
diff -cs /redis/$tname/work/cluster_node_status_default.txt /redis/$tname/work/cluster_node_status_before.txt
echo -e "================================================================================================"

# Perform failover.
echo -e "Please enter the information you wish to failover.(container, ip, port)"
read cname cip cport
docker exec $cname redis-cli -h $cip -p $cport cluster failover

rm -rf /redis/$tname/work/${TimeForm}_cluster_$tport.txt

# Check the Cluster node
echo -e "================================================================================================"
docker exec $cname redis-cli --cluster check $cip:$cport > /redis/$tname/work/cluster_node_status_after\_1.txt
cat /redis/$tname/work/cluster_node_status_after\_1.txt | cut -d '>' -f 1 | cut -d '[' -f 1 > /redis/$tname/work/cluster_node_status_after\_2.txt
rm -rf /redis/$tname/work/cluster_node_status_after\_1.txt
sed '1,6d' /redis/$tname/work/cluster_node_status_after\_2.txt > /redis/$tname/work/cluster_node_status_after\_3.txt
rm -rf /redis/$tname/work/cluster_node_status_after\_2.txt
sed -i '/1 additional/d' /redis/$tname/work/cluster_node_status_after\_3.txt
sed -i '/slots:/d' /redis/$tname/work/cluster_node_status_after\_3.txt
sed -i '/replicates/d' /redis/$tname/work/cluster_node_status_after\_3.txt
sort /redis/$tname/work/cluster_node_status_after\_3.txt | sort -k 3 > /redis/$tname/work/cluster_node_status_after\_4.txt
rm -rf /redis/$tname/work/cluster_node_status_after\_3.txt
sed '1,4d' /redis/$tname/work/cluster_node_status_after\_4.txt > /redis/$tname/work/cluster_node_status_after.txt
rm -rf /redis/$tname/work/cluster_node_status_after\_4.txt

diff -cs /redis/$tname/work/cluster_node_status_default.txt /redis/$tname/work/cluster_node_status_after.txt

rm -rf /redis/$tname/work/cluster_node_status_before.txt
rm -rf /redis/$tname/work/cluster_node_status_after.txt
echo -e "================================================================================================"

