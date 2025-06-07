#!/usr/bin/env bash

export HOSTIP=172.31.22.27
export REGISTRYPORT=5000
export CONTAINER_REPO="$HOSTIP:$REGISTRYPORT"
export BASEDOMAIN=test.foo.com
export REGISTRYINSECURE=true

[[ $EUID -ne 0 ]] && exit_on_error "Must run as root"
[[ "$REGISTRYINSECURE" != "true" ]] && exit_on_error "Only run this for an insecure registry"

#
# Setup for a local insecure registry
#
firewall-cmd --permanent --add-port=$REGISTRYPORT/tcp
firewall-cmd --reload

cat > /etc/containers/registries.conf.d/999-local-registry.conf <<EOF
[[registry]]
location = "$HOSTIP:$REGISTRYPORT"
insecure = true
EOF

# make local copy for later container build
cp /etc/containers/registries.conf.d/999-local-registry.conf .

#
# Create quadlet for registry service
#
mkdir -p /var/lib/registry

cat > /etc/containers/systemd/local-registry.container <<EOF
[Unit]
Description=A simple local registry

[Container]
Image=docker.io/library/registry:2
ContainerName=registry
PublishPort=$REGISTRYPORT:5000
Volume=/var/lib/registry:/var/lib/registry:Z

[Service]
Restart=always

[Install]
WantedBy=default.target
EOF

#
# Launch the local registry
#
systemctl daemon-reload
systemctl start local-registry

#
# create kind cluster
#

kind create cluster --config ./kind.yaml
sleep 20


#
# install flightctl from local repo
#

helm upgrade --install --namespace flightctl --create-namespace flightctl ./flightctl-local-repo.tgz --set global.registryIPandPort=$CONTAINER_REPO --set global.baseDomain=$BASEDOMAIN --set global.exposeServicesMethod=nodePort

##
## Common error function
##

exit_on_error() {
    echo
    echo "ERROR: $1"
    echo
    exit 1
}