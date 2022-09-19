#!bin/bash

. ./my.env

echo "Server name?"
read serverName
printf "\nCreating new server...\n\nImage: $IMAGE\nFlavor: $FLAVOR\nServer name: $serverName\nKey pair name: $KEYPAIR\nNetwork: $NETWORK\nSSH Security group: $SECURITY_GROUP_SSH\nWeb Security group: $SECURITY_GROUP_WEB\n"

openstack server create --image "$IMAGE" --flavor "$FLAVOR" --key-name "$KEYPAIR" --availability-zone $ZONE --network $NETWORK $serverName

SERVER_ACTIVE=$(openstack server list | grep $serverName)
echo SERVER_ACTIVE value is $SERVER_ACTIVE
IS_ACTIVE=$(echo $SERVER_ACTIVE | grep ACTIVE)

echo server status is $IS_ACTIVE
while [ -z "${IS_ACTIVE}"];
do
sleep 10
SERVER_ACTIVE=$(openstack server list | grep $serverName)
echo SERVER_ACTIVE value is $SERVER_ACTIVE
IS_ACTIVE=$(echo $SERVER_ACTIVE | grep ACTIVE)
echo server status is $IS_ACTIVE
done

echo "Server created successfully"
printf "Adding security groups to server...\nSSH Security group: $SECURITY_GROUP_SSH\nWeb Security group: $SECURITY_GROUP_WEB\n"
openstack server add security group $serverName $SECURITY_GROUP_SSH
openstack server add security group $serverName $SECURITY_GROUP_WEB

echo "Assigning floating IP to server..."
export FLOATING_IP=$(openstack floating ip create public | grep floating_ip_address | cut -d'|' -f3 | tr -d "[:blank:]")
echo "Floating IP: $FLOATING_IP"
openstack server add floating ip $serverName $FLOATING_IP
printf "\nServer created and configurated successfully\nLogin with: ssh -i $KEY_PATH ubuntu@$FLOATING_IP\n"

. ./webSetup.sh