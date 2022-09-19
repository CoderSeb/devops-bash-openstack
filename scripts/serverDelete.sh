#!bin/bash

openstack server list
# Get server names
serverNames=$(openstack server list | grep $NETWORK | cut -d'|' -f3 | tr -d "[:blank:]")
# Get floating IPs
floatingIPs=$(openstack server list | grep $NETWORK | cut -d'|' -f5 | tr -d "[:blank:]" | cut -d'=' -f2 | cut -d ',' -f2)

# Delete servers
for server in $serverNames; do
    echo "Deleting server $server..."
    openstack server delete $server
    sleep 10
    echo "Server $server deleted successfully..."
done

for ip in $floatingIPs; do
    if [[ $ip != 192.168* ]];
    then
        echo "Deleting floating IP $ip..."
        openstack floating ip delete $ip
        echo "Floating IP $ip deleted successfully..."
    fi
done
