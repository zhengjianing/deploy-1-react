#!/bin/bash

# Fail the script if an error occurs
set -e

# automatically export all variables from .env file
set -a
source .env
set +a

# Start nginx server

echo "
  set -e

  echo 'Stopping nginx server...'
  sudo service nginx stop

  echo 'Starting nginx server...'
  sudo service nginx start

" | ssh -i ${AWS_CREDENTIALS} ${AWS_EC2_ADDRESS} /bin/bash
