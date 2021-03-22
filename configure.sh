PREFIX=$1
PORT=$2

DB=$PREFIX"db"
DB_KEY_NAME=$3
DB_KEY=$4

API=$PREFIX"api"
API_KEY_NAME=$5
API_KEY=$6

echo -e "load provider scheme\n\n"
SCHEME=./deploy-schemes/$7
source $SCHEME

echo -e "Setup ${DB} && ${API}\n\n"

# Deploy services:
echo -e "Deploy VMs \n\n"
cd templates
./deploy.sh $PROVIDER_USER $WORKER $DB $PORT $DB_KEY_NAME $DB_KEY ".${SCHEME}" $SCHEME_VAGRANT_FILE
./deploy.sh $PROVIDER_USER $WORKER $API $PORT $API_KEY_NAME $API_KEY ".${SCHEME}" $SCHEME_VAGRANT_FILE

echo -e "Fetch IPs \n\n"
DB_IP=$(./fetch-ip.sh root $WORKER $DB)
API_IP=$(./fetch-ip.sh root $WORKER $API)


echo -e "Install services on both machines (${DB_IP} && ${API_IP}) \n\n"
# Install services:
./install.sh $DB_KEY sebni/soarc-database-mock $PORT "PORT=${PORT}" root $DB_IP
./install.sh $API_KEY sebni/soarc-api-endpoint $PORT "DB='http://${DB_IP}:${PORT}'\nPORT=${PORT}" root $API_IP

cd ..
echo "${DB}=${DB_IP}:${PORT}" >> $CONFIG
echo ">${API}=${API_IP}:${PORT}" >> $CONFIG
