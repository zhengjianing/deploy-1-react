#!/bin/bash

# Fail the script if an error occurs
set -e

# automatically export all variables from .env file
set -a
source .env
set +a

# Nginx path on server.
NGINX_CONF_FILE_PATH=/etc/nginx/conf.d/reactapp.conf

# 1. Creating a tmp folder in server
echo '1. Creating /tmp folder in server.'
echo "
  set -e

  TMP_PATH=/tmp
  if [ ! -d \"\$TMP_PATH\" ]; then
    echo 'Creating /tmp as it does not exist...'
    sudo mkdir -p \$TMP_PATH
  fi
" | ssh -i ${AWS_CREDENTIALS} ${AWS_EC2_ADDRESS} /bin/bash
echo 'Creating /tmp folder completed.'

# 2. Coping nginx config file to server
echo "Copying reactapp.conf to AWS EC2 instance in /tmp folder..."
scp -i ${AWS_CREDENTIALS} reactapp.conf ${AWS_EC2_ADDRESS}:/tmp
echo "Copying nginx config file completed."

# 3. Moving nginx config file from tmp folder to nginx config path from server
echo "Moving nginx config file to nginx path..."
echo "
  if [ ! -f \"$NGINX_CONF_FILE_PATH\" ]; then
    echo '$NGINX_CONF_FILE_PATH not found, copying from /tmp into /etc/nginx/conf.d'
    sudo mv /tmp/reactapp.conf /etc/nginx/conf.d
  else
    echo '$NGINX_CONF_FILE_PATH already exists, remove first and copy from /tmp again'
    sudo rm ${NGINX_CONF_FILE_PATH}
    sudo mv /tmp/reactapp.conf /etc/nginx/conf.d
  fi
" | ssh -i ${AWS_CREDENTIALS} ${AWS_EC2_ADDRESS} /bin/bash
echo "Moving nginx config file completed."
