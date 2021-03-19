#!/bin/bash
wget -c -q https://releases.hashicorp.com/vagrant/2.2.14/vagrant_2.2.14_x86_64.deb
sudo dpkg -i vagrant_2.2.14_x86_64.deb
vagrant plugin install vagrant-env # allows us to load .env files dynamically.
# Install server supplier extensions
vagrant plugin install vagrant-digitalocean # enable int. with digital ocean
