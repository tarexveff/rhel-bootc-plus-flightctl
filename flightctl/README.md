# Intention

This repository is intended to hold artifacts for creating RHEL Image Mode images 
that will be used to image edge devices managed by FlightCtl (aka Red Hat Edge Manager).
The repo also contains artifacts for creating a fully self-contained 
FlightCtl server plus container registry. both connected and airgapped).
At the moment, the files contained in this repository are a bit haphazard and disorganized
but this will be fixed in the near term.

# FlightCtl

Content TBD (from https://github.com/flightctl/flightctl/blob/main/docs/user/introduction.md)

## DNS Records

A Record: systemname.domain.foo                 X.X.X.X  
CNAME:    ui.flightctl.systemname.domain.foo    systemname.domain.foo  
CNAME:    api.flightctl.systemname.domain.foo   systemname.domain.foo  
CNAME:    auth.systemname.domain.foo            systemname.domain.foo  
CNAME:    agent-api.systemname.domain.foo       systemname.domain.foo  

## Proxied Environment Instructions

I have found that FlightCtl installation is challenging in environemnts with SSL proxies, since
the helm installation process into Kind doesn't seem to honor the host system CA certificate trusts.
This process pulls the container images for everything (except Kind itself) to your local container repository
using Skopeo, and then uses a customized helm chart to perform the installation from those images.
* Download this file([flightctl-local-helm-template.tgz](https://github.com/tarexveff/rhel-bootc-plus-flightctl/blob/main/flightctl/flightctl-local-helm-template.tgz "flightctl-local-helm-template.tgz")) and make sure it is in the same directory as the following script.
* Edit the HOSTIP and REGISTRYPORT for your container registry to what makes sense for your environment in this script: ([proxied-flightctl-container-reposync.sh](https://github.com/tarexveff/rhel-bootc-plus-flightctl/blob/main/flightctl/proxied-flightctl-container-reposync.sh "proxied-flightctl-container-reposync.sh")).  Running this script will result in a customized helm chart that references your local container registry, based on the template chart you downloaded above, and will also perform Skopeo copies of the FlightCtl/dependancy containers to your container registry, the locations of which have been placed into the customized helm chart.
* After following the [FlightCtl instructions for installing Kind and other dependencies](https://github.com/flightctl/flightctl/blob/main/docs/user/getting-started.md), replace the "helm upgrade" step command with the following variation that uses the customized helm chart created above:  `helm upgrade --install --namespace flightctl --create-namespace flightctl ./flightctl-local-helm.tgz`



