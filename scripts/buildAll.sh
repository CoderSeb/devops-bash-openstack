#!bin/bash

. ./my.env

echo "Creating router and network"
. ./createRouterAndNetwork.sh
sleep 15
echo "Creating server"
. ./createAndConfig.sh
