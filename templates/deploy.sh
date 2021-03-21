#!/bin/bash
# 1: worker-ip, 2: worker-ip
echo "create .env"
touch .env-tmp
echo "DROPLET_NAME=${3}" >> .env-tmp
echo "PROVIDER_IMAGE=${4}" >> .env-tmp
echo "PROVIDER_REGION=${5}" >> .env-tmp
echo "PROVIDER_SIZE=${6}" >> .env-tmp
echo "PROVIDER_NFS_FUNCTIONAL=${7}" >> .env-tmp
echo "DROPLET_PORT=${8}" >> .env-tmp
echo "VM_BOX=${9}" >> .env-tmp
echo "VM_BOX_URL=${10}" >> .env-tmp
echo "PROVIDER_KEY_NAME=${11}" >> .env-tmp
# We also copy a key to the path, provided in arg 12, expect its name
# save secrets:
echo "PROVIDER_TOKEN=$PROVIDER_TOKEN" >> .env-tmp
host=$1@$2
echo "transfer files"
cat "${12}" > ./key
cat "${12}.pub" > ./key.pub
# Transfer everything needed; The created env, and the vagrant file.
scp -o "StrictHostKeyChecking no" -i $SSH_KEY_PATH key key.pub .env-tmp Vagrantfile $11 "$host:/vagrant/build/"
# Delete environment:
echo "remove local tmp files"
rm .env-tmp key key.pub
# connect
echo "connect to worker"
ssh -o "StrictHostKeyChecking no" -i $SSH_KEY_PATH $host << "EOF"
  cd ../vagrant/build
  #load .env file for referencing:
  source ./.env-tmp
  path="builder-${DROPLET_NAME}"
  if [ -d "$path" ]; then
    echo "SERVICE already exists"
  else
    mkdir -p "${path}"
    cp key "${path}/key"
    cp key.pub "${path}/key.pub"
    cp .env-tmp "${path}/.env"
    cp Vagrantfile "${path}/Vagrantfile"
    rm .env-tmp Vagrantfile key key.pub
    cd "${path}"
    # 'create droplet'
    vagrant up
    # 'register droplet'
    vagrant ssh -c "ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n 1" 2>/dev/null > ip.conf
  fi
EOF
