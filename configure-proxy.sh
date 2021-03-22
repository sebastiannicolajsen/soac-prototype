PORT=$1

NAME="proxy"
KEY_NAME=$2
KEY=$3
SERVICES=$4

echo -e "${NAME} ${KEY_NAME} ${KEY}\n"
echo -e "${SERVICES}\n"
echo -e "${5}"

echo -e "load provider scheme\n\n"
SCHEME=./deploy-schemes/$5
source $SCHEME


# Deploy services:
cd templates
./deploy.sh $PROVIDER_USER $WORKER $NAME $PORT $KEY_NAME $KEY ".${SCHEME}" $SCHEME_VAGRANT_FILE

echo -e "Fetch IPs \n\n"
IP=$(./fetch-ip.sh root $WORKER $NAME)


echo -e "Install proxy service"
# Install services:
./install.sh $KEY sebni/soarc-service-proxy $PORT "PORT=${PORT}\nservices=\"${SERVICES}\"" root $IP

echo -e "proxy available on ${IP}:${PORT}"
