#!bin/bash

. ./my.env

openstack server list
# Get server names
serverNames=$(openstack server list | grep $NETWORK | cut -d'|' -f3 | tr -d "[:blank:]")
# Get floating IPs
floatingIPs=$(openstack server list | grep $NETWORK | cut -d'|' -f5 | tr -d "[:blank:]" | cut -d'=' -f2 | cut -d ',' -f2)


for server in $serverNames; do
    echo "Deleting $server..."
done

for ip in $floatingIPs; do
    echo "Deleting $ip..."
done
