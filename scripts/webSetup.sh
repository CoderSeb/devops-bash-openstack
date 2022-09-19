#!bin/bash

. ./my.env

IP=$FLOATING_IP

echo "Connecting to server ubuntu@$IP"

ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i $KEY_PATH ubuntu@$IP 'echo Connected!'
echo "Updating server..."
ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i $KEY_PATH ubuntu@$IP << EOF
  sudo apt update
EOF

echo "Server updated!"
echo "Installing and configuring Nginx..."
ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i $KEY_PATH ubuntu@$IP << EOF
  sudo apt install nginx -y
  sudo systemctl enable nginx
  sudo systemctl start nginx
EOF

echo "Nginx installed!"
echo "Configuring..."

scp -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i $KEY_PATH files/index.html ubuntu@$IP:./index.html

scp -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i $KEY_PATH files/sebspage ubuntu@$IP:./sebspage

ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i $KEY_PATH ubuntu@$IP << EOF
  sudo mkdir -p /var/www/html
  sudo mv index.html /var/www/html/index.html
  sudo mv sebspage /etc/nginx/sites-available/sebspage
  sudo ln -s /etc/nginx/sites-available/sebspage /etc/nginx/sites-enabled/
  sudo systemctl restart nginx
EOF

printf "\nConfigured!\nConnect with: ssh -i $KEY_PATH ubuntu@$IP\nWeb page available @ http://$IP\n"