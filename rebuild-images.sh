{\rtf1\ansi\ansicpg1252\cocoartf2761
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 #!/usr/bin/env bash\
. ./demo.conf\
\
podman build --no-cache -f BaseContainerfile -t $CONTAINER_REPO:base --build-arg DEMO_USER=$DEMO_USER\
podman push $CONTAINER_REPO:base\
\
podman build --no-cache -f FGBaseContainerfile -t $CONTAINER_REPO:fgfs --build-arg CONTAINER_REPO=$CONTAINER_REPO\
podman push $CONTAINER_REPO:fgfs\
\
podman build --no-cache -f FGDemoContainerfile -t $CONTAINER_REPO:f35-fixed --build-arg CONTAINER_REPO=$CONTAINER_REPO --build-arg DL_SCENARIO=AircraftCache/F-35B/ --build-arg FGDEMO_CONF=fgdemo1.conf\
podman build --no-cache -f FGDemoContainerfile -t $CONTAINER_REPO:f22-fixed --build-arg CONTAINER_REPO=$CONTAINER_REPO --build-arg DL_SCENARIO=AircraftCache/Lockheed-Martin-FA-22A-Raptor/ --build-arg FGDEMO_CONF=fgdemo2.conf\
podman build --no-cache -f FGDemoContainerfile -t $CONTAINER_REPO:b52-fixed --build-arg CONTAINER_REPO=$CONTAINER_REPO --build-arg DL_SCENARIO=AircraftCache/B-52F/ --build-arg FGDEMO_CONF=fgdemo3.conf\
podman build --no-cache -f FGDemoContainerfile -t $CONTAINER_REPO:uh60-fixed --build-arg CONTAINER_REPO=$CONTAINER_REPO --build-arg DL_SCENARIO=AircraftCache/UH-60/ --build-arg FGDEMO_CONF=fgdemo4.conf\
\
podman push $CONTAINER_REPO:f35-fixed\
podman push $CONTAINER_REPO:f22-fixed\
podman push $CONTAINER_REPO:b52-fixed\
podman push $CONTAINER_REPO:uh60-fixed}