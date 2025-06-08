#!/usr/bin/env bash

export HOSTIP=172.31.22.27
export REGISTRYPORT=5000
export CONTAINER_REPO="$HOSTIP:$REGISTRYPORT"


export postgresImage=$CONTAINER_REPO/sclorg/postgresql-16-c9s
export redisImage=$CONTAINER_REPO/library/redis
export apiImage=$CONTAINER_REPO/flightctl/flightctl-api
export artifactsImage=$CONTAINER_REPO/flightctl/flightct-cli-artifacts
export workerImage=$CONTAINER_REPO/flightctl/flightctl-worker
export periodicImage=$CONTAINER_REPO/flightctl/flightctl-periodic
export origincliImage=$CONTAINER_REPO/openshift/origin-cli
export keycloakImage=$CONTAINER_REPO/keycloak/keycloak
export uiImage=$CONTAINER_REPO/flightctl/flightctl-ui

# Unpack templated helm chart
gunzip < ./flightctl-local-helm-template.tgz | tar xf -

#Substitute image names in flightctl-local-helm/values.yaml

sed -i -e "s,POSTGRES-VARIABLE-SUB,$postgresImage," ./flightctl-local-helm/values.yaml
sed -i -e "s,REDIS-VARIABLE-SUB,$redisImage," ./flightctl-local-helm/values.yaml
sed -i -e "s,API-VARIABLE-SUB,$apiImage," ./flightctl-local-helm/values.yaml
sed -i -e "s,ARTIFACTS-VARIABLE-SUB,$artifactsImage," ./flightctl-local-helm/values.yaml
sed -i -e "s,WORKER-VARIABLE-SUB,$workerImage," ./flightctl-local-helm/values.yaml
sed -i -e "s,PERIODIC-VARIABLE-SUB,$periodicImage," ./flightctl-local-helm/values.yaml
sed -i -e "s,ORIGIN-CLI-VARIABLE-SUB,$origincliImage," ./flightctl-local-helm/values.yaml

# in ./flightctl-local-helm/charts/ui/templates/flightctl-ui-deployment.yaml

sed -i -e "s,UI-VARIABLE-SUB,$uiImage," ./flightctl-local-helm/charts/ui/templates/flightctl-ui-deployment.yaml

#Substitute image names in flightctl-local-helm/charts/keycloak/values.yaml

sed -i -e "s,KEYCLOAK-VARIABLE-SUB,$keycloakImage," ./flightctl-local-helm/charts/keycloak/values.yaml
sed -i -e "s,POSTGRES-VARIABLE-SUB,$postgresImage," ./flightctl-local-helm/charts/keycloak/values.yaml

# Re-pack helm chart
tar -czf flightctl-local-helm.tgz flightctl-local-helm
rm -rf ./flightctl-local-helm
