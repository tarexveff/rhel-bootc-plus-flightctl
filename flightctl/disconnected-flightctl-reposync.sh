#!/usr/bin/env bash

export REGISTRYPORT=5000
export HOSTIP=172.31.22.27
export CONTAINER_REPO="$HOSTIP:$REGISTRYPORT"

export SKOPEO=false
export CONNECTED_SYSTEM=false
export DISCONNECTED_SYSTEM=false

if [ $SKOPEO == "true"]; then

skopeo copy docker://quay.io/flightctl/flightctl-cli-artifacts:0.7.1 docker://$CONTAINER_REPO/flightctl/flightct-cli-artifacts:0.7.1
skopeo copy docker://quay.io/flightctl/flightctl-api:0.7.1 docker://$CONTAINER_REPO/flightctl/flightctl-api:0.7.1
skopeo copy docker://quay.io/flightctl/flightctl-periodic:0.7.1 docker://$CONTAINER_REPO/flightctl/flightctl-periodic:0.7.1
skopeo copy docker://quay.io/flightctl/flightctl-ui:0.7.1 docker://$CONTAINER_REPO/flightctl/flightctl-ui:0.7.1
skopeo copy docker://quay.io/flightctl/flightctl-worker:0.7.1 docker://$CONTAINER_REPO/flightctl/flightctl-worker:0.7.1
skopeo copy docker://quay.io/keycloak/keycloak:25.0.1 docker://$CONTAINER_REPO/keycloak/keycloak:latest
skopeo copy docker://quay.io/quay.io/openshift/origin-cli:4.20.0 docker://$CONTAINER_REPO/openshift/origin-cli:4.20.0
skopeo copy docker://quay.io/sclorg/postgresql-16-c9s:20250214 docker://$CONTAINER_REPO/sclorg/postgresql-16-c9s:latest
skopeo copy docker://docker.io/library/redis:7.4.1 docker://$CONTAINER_REPO/library/redis:7.4.1
# Redis needs to be done manually - revisit
exit 0
fi

if [ $CONNECTED_SYSTEM == "true"]; then

#Pull images to podman

for component in api cli-artifacts periodic ui worker
do podman pull quay.io/flightctl/flightctl-$component:0.7.1
done

podman pull quay.io/keycloak/keycloak:25.0.1
podman pull quay.io/openshift/origin-cli:4.20.0
podman pull quay.io/sclorg/postgresql-16-c9s:20250214
podman pull docker.io/library/redis:7.4.1

#Save images to tar archives from connected system

for component in api cli-artifacts periodic ui worker
do podman save quay.io/flightctl/flightctl-$component:0.7.1 -o $component.tar
done

podman save quay.io/keycloak/keycloak:25.0.1 -o keycloak.tar
podman save quay.io/openshift/origin-cli:4.20.0 -o origin-cli.tar
podman save quay.io/sclorg/postgresql-16-c9s:latest -o postgres.tar
podman save docker.io/library/redis:7.4.1 -o redis-7.4.1.tar

exit 0
fi

if [ $DISCONNECTED_SYSTEM == "true"]; then

# Move tar files from connected system to disconnected system and Load images

for component in  api cli-artifacts periodic ui worker keycloak origin-cli postgres redis-7.4.1
do podman load --input $component.tar
done

# Re-tag images


podman image tag quay.io/keycloak/keycloak:25.0.1 $CONTAINER_REPO/keycloak/keycloak:latest
podman image tag quay.io/openshift/origin-cli:4.20.0 $CONTAINER_REPO/openshift/origin-cli:4.20.0
podman image tag quay.io/sclorg/postgresql-16-c9s:20250214 $CONTAINER_REPO/sclorg/postgresql-16-c9s:latest
podman image tag docker.io/library/redis:7.4.1 $CONTAINER_REPO/library/redis:20250108
podman image tag quay.io/flightctl/flightctl-api:0.7.1 $CONTAINER_REPO/flightctl/flightctl-api:0.7.1
podman image tag quay.io/flightctl/flightctl-cli-artifacts:0.7.1 $CONTAINER_REPO/flightctl/flightctl-cli-artifacts:0.7.1
podman image tag quay.io/flightctl/flightctl-periodic:0.7.1 $CONTAINER_REPO/flightctl/flightctl-periodic:0.7.1
podman image tag quay.io/flightctl/flightctl-ui:0.7.1 $CONTAINER_REPO/flightctl/flightctl-ui:0.7.1
podman image tag quay.io/flightctl/flightctl-worker:0.7.1 $CONTAINER_REPO/flightctl/flightctl-worker:0.7.1


#Push to local registry
podman push $CONTAINER_REPO/keycloak/keycloak:latest
podman push $CONTAINER_REPO/openshift/origin-cli:4.20.0
podman push $CONTAINER_REPO/sclorg/postgresql-16-c9s:latest
podman push $CONTAINER_REPO/library/redis:20250108
podman push $CONTAINER_REPO/flightctl/flightctl-api:0.7.1
podman push $CONTAINER_REPO/flightctl/flightctl-cli-artifacts:0.7.1
podman push $CONTAINER_REPO/flightctl/flightctl-periodic:0.7.1
podman push $CONTAINER_REPO/flightctl/flightctl-ui:0.7.1
podman push $CONTAINER_REPO/flightctl/flightctl-worker:0.7.1
 

exit 0
