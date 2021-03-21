#!/bin/bash

host=$1@$2
export LC_SERVICE=$3
echo $(ssh -o "StrictHostKeyChecking no" -o "SendEnv LC_SERVICE" -i ~/.ssh/digitalocean_rsa $host << "EOF"
    echo $(cat "/vagrant/build/builder-${LC_SERVICE}/ip.conf")
EOF)
