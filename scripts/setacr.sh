#!/bin/bash

set -e

RG="bart-rg"
ACR_NAME="bartacr"
ACI_TEST_NAME="apitestcontainer"
ACI_API_NAME="apicontainer"
LOCATION="westeurope"

az acr create \
    --resource-group $RG \
    --name $ACR_NAME \
    --sku Standard \
    --admin-enable true \
    --location $LOCATION


ACR_SERVER_NAME=$(az acr show --name $ACR_NAME --query loginServer --output tsv)
ACR_USERNAME=$(az acr show --name $ACR_NAME --query name --output tsv)
ACR_PASSWORD=$(az acr credential show --name $ACR_NAME --query "passwords[0].value" --output tsv)

az acr login --name $ACR_NAME --username $ACR_USERNAME --password $ACR_PASSWORD

docker build -t apitest -f Dockerfile.test .
docker build -t apidev -f Dockerfile.dev .

docker tag apitest:latest $ACR_SERVER_NAME/apitest
docker push $ACR_SERVER_NAME/apitest

docker tag apidev:latest $ACR_SERVER_NAME/apidev
docker push $ACR_SERVER_NAME/apidev

az container create --resource-group $RG \
    --name $ACI_TEST_NAME \
    --registry-login-server $ACR_SERVER_NAME \
    --registry-username $ACR_USERNAME \
    --registry-password $ACR_PASSWORD \
    --restart-policy Never \
    --image $ACR_SERVER_NAME/apitest

az container create --resource-group $RG \
    --name $ACI_API_NAME \
    --registry-login-server $ACR_SERVER_NAME \
    --registry-username $ACR_USERNAME \
    --registry-password $ACR_PASSWORD \
    --restart-policy OnFailure \
    --ip-address Public \
    --image $ACR_SERVER_NAME/apidev

