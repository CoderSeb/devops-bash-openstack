#!bin/bash

. ./my.env

echo "Creating router: $ROUTER"
openstack router create $ROUTER
openstack router set --external-gateway public $ROUTER
echo "Router created successfully..."
echo "Creating network: $NETWORK"
openstack network create $NETWORK
echo "Network created successfully..."
echo "Creating subnet: $SUBNET"
openstack subnet create --subnet-range 192.168.0.0/24 --dns-nameserver 194.47.110.95 --dns-nameserver 194.47.110.96 --network $NETWORK $SUBNET
openstack router add subnet $ROUTER $SUBNET
echo "Subnet created successfully..."