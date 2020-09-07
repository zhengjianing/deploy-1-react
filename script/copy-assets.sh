#!/bin/bash

# Fail the script if an error occurs
set -e

# automatically export all variables from .env file
set -a
source .env
set +a

# The /build folder of the react app in your local machine (Assumption: we deploy from local machine.)
# Make sure you run `npm run build` to generate the latest production /build files for the react application
BUILD_ASSETS_FOLDER=../build

# Tmp folder on server.
TMP_ASSETS_PATH=/tmp/ui-build

# 1. Creating a tmp folder in server
echo '1. Creating /tmp/ui-build folder in server.'
echo "
  set -e

  TMP_ASSETS_PATH=/tmp/ui-build
  if [ ! -d \"\$TMP_ASSETS_PATH\" ]; then
    echo 'Creating /tmp/ui-build as it does not exist...'
    sudo mkdir -p \$TMP_ASSETS_PATH
  fi
" | ssh -i ${AWS_CREDENTIALS} ${AWS_EC2_ADDRESS} /bin/bash
echo 'Creating /tmp/ui-build folder completed.'

# 2. Coping react build assets to server
echo "2. Copying react build assets to server ${TMP_ASSETS_PATH} folder..."
if [ ! -e ${BUILD_ASSETS_FOLDER} ]; then
  echo "Cannot find build/ folder to scp"
  exit -1
fi
scp -i ${AWS_CREDENTIALS} -r ${BUILD_ASSETS_FOLDER}/* ${AWS_EC2_ADDRESS}:${TMP_ASSETS_PATH}
echo "Copy assets completed."

# 3. Moving react build assets from tmp folder to nginx accessible folder
echo "3. Moving react build assets from ${TMP_ASSETS_PATH} folder to nginx accessible folder."
echo "
  set -e

  TMP_ASSETS_PATH=/tmp/ui-build
  APP_DIRECTORY=/opt/myapp
  UI_APP_DIRECTORY=\$APP_DIRECTORY/ui
  if [ ! -d \"\$UI_APP_DIRECTORY\" ]; then
    echo 'Creating \$UI_APP_DIRECTORY as it does not exist...'
    sudo mkdir -p \$UI_APP_DIRECTORY
  fi

  echo 'Removing previous build files...'
  sudo rm -rf \$UI_APP_DIRECTORY/*

  echo 'Copying new build files into app directory...'
  sudo mv \$TMP_ASSETS_PATH/* \$UI_APP_DIRECTORY

" | ssh -i ${AWS_CREDENTIALS} ${AWS_EC2_ADDRESS} /bin/bash
echo 'Moving react build assets completed.'
