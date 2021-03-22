export WORKER=67.205.128.26 # used by configure
export CONFIG=ips.conf # used by configure

rm $CONFIG # clean list of configures
touch $CONFIG
# Configure [prefix] [port] [ssh1 name] [ssh1 path] [ssh2 name] [ssh2 path] [Deploy scheme]
./configure.sh "Hospital4-" 9090 vagrant3 ~/.ssh/vagrant3 vagrant2 ~/.ssh/vagrant2 digitalocean.conf
./configure.sh "Hospital3-" 9090 vagrant4 ~/.ssh/vagrant4 vagrant5 ~/.ssh/vagrant5 digitalocean.conf




# setup proxy service:
# load endpoints:
SERVICES=$(
while read line
do
  echo -n "|${line}"
done < $CONFIG)

# deploy proxy:
./configure-proxy.sh 9090 vagrant6 ~/.ssh/vagrant6 "${SERVICES}" digitalocean.conf
