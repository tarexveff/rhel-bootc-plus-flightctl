#!/usr/bin/env bash

if [ ! -f ~/.ssh/id_core ]; then
    ssh-keygen -t rsa -f ~/.ssh/id_core
fi

. $(dirname $0)/demo.conf

podman login registry.redhat.io
podman pull registry.redhat.io/rhel9/rhel-bootc:9.6
podman build -f BaseContainerfile -t $IMAGE_NAME:base \
    --build-arg DEMO_USER=$DEMO_USER
