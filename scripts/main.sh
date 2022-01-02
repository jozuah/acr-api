#!/bin/bash

set -e

# **************************************
# CONFIG *******************************
# **************************************
USERNAME="cisaia@simplonformations.onmicrosoft.com"
LOCATION="westeurope"
RG="clement_i"
APPNAME="api"
ENV="dev"

################
# REGISTRY PARAMS
###############
REGISTRY_NAME="${APPNAME}${ENV}001"

# **************************************

################
# REGISTRY INIT
###############

# Ne pas afficher le mot de passe dans la console
read -sp "Azure password: " AZ_PASS && echo && az login -u $USERNAME -p $AZ_PASS

# On vérifie si le registre existe, si ce n'est pas le cas on le créé
if [ `echo "$(az acr check-name -n $REGISTRY_NAME)" | jq -r '.message'` == "null" ]; then
        echo "Registry not exists"
        sh create-registry.sh $LOCATION $RG $REGISTRY_NAME
fi

sh build-push-deploy-container.sh $REGISTRY_NAME $APPNAME $ENV $RG
