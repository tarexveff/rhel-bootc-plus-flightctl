#!/usr/bin/env bash
#
# Make sure your proxy's CA certificate is trusted by the RHEL system you are running this on:
# https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/securing_networks/using-shared-system-certificates_securing-networks
#

export REGISTRYPORT=5000
export HOSTIP=172.31.22.27
export CONTAINER_REPO="$HOSTIP:$REGISTRYPORT"

skopeo copy --dest-tls-verify=false docker://quay.io/flightctl/flightctl-cli-artifacts:0.8.0 docker://$CONTAINER_REPO/flightctl/flightct-cli-artifacts:latest
skopeo copy --dest-tls-verify=false docker://quay.io/flightctl/flightctl-api:0.8.0 docker://$CONTAINER_REPO/flightctl/flightctl-api:latest
skopeo copy --dest-tls-verify=false docker://quay.io/flightctl/flightctl-periodic:0.8.0 docker://$CONTAINER_REPO/flightctl/flightctl-periodic:latest
skopeo copy --dest-tls-verify=false docker://quay.io/flightctl/flightctl-ui:0.8.0 docker://$CONTAINER_REPO/flightctl/flightctl-ui:latest
skopeo copy --dest-tls-verify=false docker://quay.io/flightctl/flightctl-worker:0.8.0 docker://$CONTAINER_REPO/flightctl/flightctl-worker:latest
skopeo copy --dest-tls-verify=false docker://quay.io/keycloak/keycloak:25.0.1 docker://$CONTAINER_REPO/keycloak/keycloak:latest
skopeo copy --dest-tls-verify=false docker://quay.io/openshift/origin-cli:4.20.0 docker://$CONTAINER_REPO/openshift/origin-cli:latest
skopeo copy --dest-tls-verify=false docker://quay.io/sclorg/postgresql-16-c9s:20250214 docker://$CONTAINER_REPO/sclorg/postgresql-16-c9s:latest
skopeo copy --dest-tls-verify=false docker://quay.io/sclorg/redis-7-c9s:20250108 docker://$CONTAINER_REPO/library/redis:latest
exit 0
fi


exit 0
