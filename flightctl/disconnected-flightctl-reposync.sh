#!/usr/bin/env bash

export REGISTRYPORT=5000
export HOSTIP=172.31.22.27
export CONTAINER_REPO="$HOSTIP:$REGISTRYPORT"

export SKOPEO=false
export CONNECTED_SYSTEM=false
export DISCONNECTED_SYSTEM=false

if [ $SKOPEO == "true"]; then

skopeo copy --dest-tls-verify=false docker://quay.io/flightctl/flightctl-cli-artifacts:0.7.1 docker://$CONTAINER_REPO/flightctl/flightct-cli-artifacts:latest
skopeo copy --dest-tls-verify=false docker://quay.io/flightctl/flightctl-api:0.7.1 docker://$CONTAINER_REPO/flightctl/flightctl-api:latest
skopeo copy --dest-tls-verify=false docker://quay.io/flightctl/flightctl-periodic:0.7.1 docker://$CONTAINER_REPO/flightctl/flightctl-periodic:latest
skopeo copy --dest-tls-verify=false docker://quay.io/flightctl/flightctl-ui:0.7.1 docker://$CONTAINER_REPO/flightctl/flightctl-ui:latest
skopeo copy --dest-tls-verify=false docker://quay.io/flightctl/flightctl-worker:0.7.1 docker://$CONTAINER_REPO/flightctl/flightctl-worker:latest
skopeo copy --dest-tls-verify=false docker://quay.io/keycloak/keycloak:25.0.1 docker://$CONTAINER_REPO/keycloak/keycloak:latest
skopeo copy --dest-tls-verify=false docker://quay.io/quay.io/openshift/origin-cli:4.20.0 docker://$CONTAINER_REPO/openshift/origin-cli:latest
skopeo copy --dest-tls-verify=false docker://quay.io/sclorg/postgresql-16-c9s:20250214 docker://$CONTAINER_REPO/sclorg/postgresql-16-c9s:latest
skopeo copy --dest-tls-verify=false docker://docker.io/library/redis:7.4.1 docker://$CONTAINER_REPO/library/redis:latest
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
podman image tag quay.io/openshift/origin-cli:4.20.0 $CONTAINER_REPO/openshift/origin-cli:latest
podman image tag quay.io/sclorg/postgresql-16-c9s:20250214 $CONTAINER_REPO/sclorg/postgresql-16-c9s:latest
podman image tag docker.io/library/redis:7.4.1 $CONTAINER_REPO/library/redis:latest
podman image tag quay.io/flightctl/flightctl-api:0.7.1 $CONTAINER_REPO/flightctl/flightctl-api:latest
podman image tag quay.io/flightctl/flightctl-cli-artifacts:0.7.1 $CONTAINER_REPO/flightctl/flightctl-cli-artifacts:latest
podman image tag quay.io/flightctl/flightctl-periodic:0.7.1 $CONTAINER_REPO/flightctl/flightctl-periodic:latest
podman image tag quay.io/flightctl/flightctl-ui:0.7.1 $CONTAINER_REPO/flightctl/flightctl-ui:latest
podman image tag quay.io/flightctl/flightctl-worker:0.7.1 $CONTAINER_REPO/flightctl/flightctl-worker:latest


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
 

exit 0
