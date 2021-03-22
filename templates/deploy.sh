#!/bin/bash
# 1: worker-ip, 2: worker-ip
echo "create .env"
touch .env-tmp
echo "DROPLET_NAME=${3}" >> .env-tmp
echo "DROPLET_PORT=${4}" >> .env-tmp
echo "PROVIDER_KEY_NAME=${5}" >> .env-tmp
#add all parts of scheme selected:
while read line
do
  eval echo $line >> .env-tmp
done < $7

host=$1@$2
echo "transfer files"
cat "${6}" > ./key
cat "${6}.pub" > ./key.pub
cp "vagrantfiles/${8}" ./Vagrantfile
# Transfer everything needed; The created env, and the vagrant file.
scp -o "StrictHostKeyChecking no" -i $SSH_KEY_PATH key key.pub .env-tmp Vagrantfile "$host:/vagrant/build/"
# Delete environment:
echo "remove local tmp files"
rm .env-tmp key key.pub Vagrantfile
# connect
echo "connect to worker"
ssh -o "StrictHostKeyChecking no" -i $SSH_KEY_PATH $host << "EOF"
  cd ../vagrant/build
  #load .env file for referencing:
  source ./.env-tmp
  path="builder-${DROPLET_NAME}"
  if [ -d "$path" ]; then
    rm .env-tmp Vagrantfile key key.pub
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
