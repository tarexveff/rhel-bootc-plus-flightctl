#!/usr/bin/env bash
#
# This script will perform Skopeo copies of the FlightCtl/dependancy containers to your container registry
# so that your proxy does not block the helm installation of FlightCtl into Kind.  There may be a more elegant way
# to achieve this, but this process should work for you, and may also help other builds that have issues with your proxy.  
# This process can also be adapted for fully disconnected installations (addressed in other scripts in this repo)
# The script also creates a customized helm chart that references your local container registry,
# based on the template chart you will download below.
#
# Ideally, make sure your proxy's CA certificate is trusted by the RHEL system you are running this on, though the TLS verify flag for skopeo might be enough:
# https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/securing_networks/using-shared-system-certificates_securing-networks
#
#
# !!!!! This script requires that the flightctl-local-helm-template.tgz archive in this repository is downloaded to the same directory !!!!!
# https://github.com/tarexveff/rhel-bootc-plus-flightctl/blob/main/flightctl/flightctl-local-helm-template.tgz
#

# Customize the CONTAINER_REPO for the local registry in your environment where containers will be copied to

export CONTAINER_REPO=registry.foo:5000
export FLIGHTCTL_VERSION=0.8.0

skopeo copy --dest-tls-verify=false docker://quay.io/flightctl/flightctl-cli-artifacts:$FLIGHTCTL_VERSION docker://$CONTAINER_REPO/flightctl/flightct-cli-artifacts:latest
skopeo copy --dest-tls-verify=false docker://quay.io/flightctl/flightctl-api:$FLIGHTCTL_VERSION docker://$CONTAINER_REPO/flightctl/flightctl-api:latest
skopeo copy --dest-tls-verify=false docker://quay.io/flightctl/flightctl-periodic:$FLIGHTCTL_VERSION docker://$CONTAINER_REPO/flightctl/flightctl-periodic:latest
skopeo copy --dest-tls-verify=false docker://quay.io/flightctl/flightctl-ui:$FLIGHTCTL_VERSION docker://$CONTAINER_REPO/flightctl/flightctl-ui:latest
skopeo copy --dest-tls-verify=false docker://quay.io/flightctl/flightctl-worker:$FLIGHTCTL_VERSION docker://$CONTAINER_REPO/flightctl/flightctl-worker:latest
skopeo copy --dest-tls-verify=false docker://quay.io/keycloak/keycloak:25.0.1 docker://$CONTAINER_REPO/keycloak/keycloak:latest
skopeo copy --dest-tls-verify=false docker://quay.io/openshift/origin-cli:4.20.0 docker://$CONTAINER_REPO/openshift/origin-cli:latest
skopeo copy --dest-tls-verify=false docker://quay.io/sclorg/postgresql-16-c9s:20250214 docker://$CONTAINER_REPO/sclorg/postgresql-16-c9s:latest
skopeo copy --dest-tls-verify=false docker://quay.io/sclorg/redis-7-c9s:20250108 docker://$CONTAINER_REPO/library/redis:latest
exit 0
fi

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

exit 0
