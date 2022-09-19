#!bin/bash

. ./my.env

# Get info
echo "Tear down script running..."

# Delete servers
. ./serverDelete.sh

# Delete subnet & network
echo "Removing subnet from router..."
openstack router remove subnet $ROUTER $SUBNET
echo "Subnet removed successfully..."
echo "Deleting subnet..."
openstack subnet delete $SUBNET
echo "Subnet deleted successfully..."
echo "Deleting network..."
openstack network delete $NETWORK
echo "Network deleted successfully..."

# Delete router
echo "Deleting router..."
openstack router unset --external-gateway $ROUTER
openstack router delete $ROUTER
echo "Router deleted successfully..."

echo "Tear down script finished successfully!"
