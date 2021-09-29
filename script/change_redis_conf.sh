# Change the Bind(IP)
echo -e "What do you want to change bind?"
read cbind

# Change the Port
echo -e "What do you want to change the port?"
read cport

#sed -n "s/bind/bind $cbind/p" /root/test_git/git_file/redis.conf > redis1.conf

sed -n "s/port 6379/port $cport/p" /root/test_git/git_file/redis.conf > redis1.conf

