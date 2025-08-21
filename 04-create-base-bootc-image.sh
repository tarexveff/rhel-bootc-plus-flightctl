#!/usr/bin/env bash

#if [ ! -f ~/.ssh/id_core ]; then
#    ssh-keygen -t rsa -f ~/.ssh/id_core
#fi

. $(dirname $0)/env.conf

podman login registry.redhat.io
podman pull registry.redhat.io/rhel9/rhel-bootc:9.6
podman build -t "${IMAGE_NAME}:base" --build-arg USER_PASSWD="${USER_PASSWORD}" -f BaseContainerFile-gnome
