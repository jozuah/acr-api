#!/bin/bash

REGISTRY_NAME=$1
APPNAME=$2
ENV=$3
RG=$4
ACR_SERVER_NAME=$(az acr show --name $REGISTRY_NAME --query loginServer --output tsv)
ACR_USERNAME=$(az acr show --name $REGISTRY_NAME --query name --output tsv)
ACR_PASSWORD=$(az acr credential show --name $REGISTRY_NAME --query "passwords[0].value" --output tsv)
echo $ACR_SERVER_NAME
echo $ACR_USERNAME
echo $ACR_PASSWORD

docker build -t ${APPNAME}${ENV} -f ../docker/Dockerfile.${ENV} ../
docker tag ${APPNAME}${ENV}:latest $ACR_SERVER_NAME/${APPNAME}${ENV}
docker login $ACR_SERVER_NAME -u $ACR_USERNAME -p $ACR_PASSWORD
docker push $ACR_SERVER_NAME/${APPNAME}${ENV}

az container create --resource-group $RG \
    --name ${APPNAME}${ENV}"container" \
    --registry-login-server $ACR_SERVER_NAME \
    --registry-username $ACR_USERNAME \
    --registry-password $ACR_PASSWORD \
    --restart-policy OnFailure \
    --ip-address Public \
    --ports 8080 \
    --image $ACR_SERVER_NAME/${APPNAME}${ENV}
