#!/usr/bin/env bash

export REGISTRYPORT=5000
export HOSTIP=X.X.X.X
export CONTAINER_REPO="$HOSTIP:$REGISTRYPORT"

# Load images from tar

for component in  api cli-artifacts periodic ui worker keycloak origin-cli postgres redis-7.4.1 kind
do podman load --input $component.tar
done

# Re-tag images

podman image tag quay.io/keycloak/keycloak:25.0.1 $CONTAINER_REPO/keycloak/keycloak:latest
podman image tag quay.io/openshift/origin-cli:4.20.0 $CONTAINER_REPO/openshift/origin-cli:latest
podman image tag quay.io/sclorg/postgresql-16-c9s:20250214 $CONTAINER_REPO/sclorg/postgresql-16-c9s:latest
podman image tag docker.io/library/redis:7.4.1 $CONTAINER_REPO/library/redis:latest
podman image tag quay.io/flightctl/flightctl-api:0.7.1 $CONTAINER_REPO/flightctl/flightctl-api:latest
podman image tag quay.io/flightctl/flightctl-cli-artifacts:0.7.1 $CONTAINER_REPO/flightctl/flightctl-cli-artifacts:latest
podman image tag quay.io/flightctl/flightctl-periodic:0.7.1 $CONTAINER_REPO/flightctl/flightctl-periodic:latest
podman image tag quay.io/flightctl/flightctl-ui:0.7.1 $CONTAINER_REPO/flightctl/flightctl-ui:latest
podman image tag quay.io/flightctl/flightctl-worker:0.7.1 $CONTAINER_REPO/flightctl/flightctl-worker:latest
podman image tag docker.io/kindest/node $CONTAINER_REPO/kindest/node:latest

#Push to local registry
podman push $CONTAINER_REPO/keycloak/keycloak:latest
podman push $CONTAINER_REPO/openshift/origin-cli:latest
podman push $CONTAINER_REPO/sclorg/postgresql-16-c9s:latest
podman push $CONTAINER_REPO/library/redis:latest
podman push $CONTAINER_REPO/flightctl/flightctl-api:latest
podman push $CONTAINER_REPO/flightctl/flightctl-cli-artifacts:latest
podman push $CONTAINER_REPO/flightctl/flightctl-periodic:latest
podman push $CONTAINER_REPO/flightctl/flightctl-ui:latest
podman push $CONTAINER_REPO/flightctl/flightctl-worker:latest
podman push $CONTAINER_REPO/kindest/node:latest
