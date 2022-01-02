# Installation

## Localement

````docker-compose up --build````

## Azure


### Configuration

Dans le script main.sh

**3 environments:**

- dev
- test
- prod

### Prérequis

- Installer [AZ CLI](https://docs.microsoft.com/fr-fr/cli/azure/install-azure-cli)
- Installer [JQ](https://stedolan.github.io/jq/)

### Scripts

Piloter le conteneur sur Azure, du build au déploiement
```bash
sh main.sh
```  


# API

[http://localhost:8080/text/uppercase?source=test](http://localhost:8080/text/uppercase?source=test)

[http://localhost:8080/text/palindrome?source=radar](http://localhost:8080/text/palindrome?source=radar)
