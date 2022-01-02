#!/bin/bash

LOCATION=$1
RG=$2
REGISTRY_NAME=$3


az login
az group create --location $LOCATION --resource-group $RG
az acr create \
    --resource-group $RG \
    --name $REGISTRY_NAME \
    --sku Basic \
    --admin-enable true \
    --location $LOCATION