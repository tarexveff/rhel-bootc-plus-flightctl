#!/usr/bin/env bash

export HOSTIP=192.168.1.10
export REGISTRYPORT=5000
export CONTAINER_REPO="$HOSTIP:$REGISTRYPORT"


export postgresImage: "$CONTAINER_REPO/sclorg/postgresql-16-c9s"
export redisImage: "$CONTAINER_REPO/library/redis"
export apiImage: "$CONTAINER_REPO/flightctl/flightctl-api"
export artifactsImage: "$CONTAINER_REPO/flightctl/flightct-cli-artifacts"
export workerImage: "$CONTAINER_REPO/flightctl/flightctl-worker"
export periodicImage: "$CONTAINER_REPO/flightctl/flightctl-periodic"
export origincliImage: "$CONTAINER_REPO/openshift/origin-cli"
export keycloakImage: "$CONTAINER_REPO/keycloak/keycloak:25.0.1"
export uiImage: "$CONTAINER_REPO/flightctl/flightctl-ui"

#in ./flightctl/values.yaml

sed -i -e 's/POSTGRES-VARIABLE-SUB/$postgresImage/' ./flightctl/values.yaml
sed -i -e 's/REDIS-VARIABLE-SUB/$redisImage/' ./flightctl/values.yaml
sed -i -e 's/POSTGRES-VARIABLE-SUB/$apiImage/' ./flightctl/values.yaml
sed -i -e 's/POSTGRES-VARIABLE-SUB/$artifactsImage/' ./flightctl/values.yaml
sed -i -e 's/POSTGRES-VARIABLE-SUB/$workerImage/' ./flightctl/values.yaml
sed -i -e 's/POSTGRES-VARIABLE-SUB/$periodicImage/' ./flightctl/values.yaml
sed -i -e 's/ORIGIN-CLI-VARIABLE-SUB/$origincliImage/' ./flightctl/values.yaml

#POSTGRES-VARIABLE-SUB
#REDIS-VARIABLE-SUB
#ARTIFACTS-VARIABLE-SUB
#WORKER-VARIABLE-SUB
#PERIODIC-VARIABLE-SUB
#ORIGIN-CLI-VARIABLE-SUB

#in ./flightctl-local-helm-template/charts/ui/templates/flightctl-ui-deployment.yaml
#FLIGHTCTLUI-VARIABLE-SUB

sed -i -e 's/FLIGHTCTLUI-VARIABLE-SUB/$uiImage/' ./flightctl/values.yaml

#in ./flightctl-local-helm-template/charts/keycloak/values.yaml

#KEYCLOAK-VARIABLE-SUB
#POSTGRES-VARIABLE-SUB

sed -i -e 's/KEYCLOAK-VARIABLE-SUB/$keycloakImage/' ./flightctl/charts/keycloak/values.yaml
sed -i -e 's/POSTGRES-VARIABLE-SUB/$postgresImage/' ./flightctl/charts/keycloak/values.yaml

