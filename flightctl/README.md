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
* Item
* Item
* Item


Some text with [customize-helm.sh][1] and
another [flightctl-local-helm-template.tgz][2] and another [proxied-flightctl-container-reposync.sh][3]
[1]: https://github.com/tarexveff/rhel-bootc-plus-flightctl/blob/main/flightctl/customize-helm.sh
[2]: https://github.com/tarexveff/rhel-bootc-plus-flightctl/blob/main/flightctl/flightctl-local-helm-template.tgz
[3]: https://github.com/tarexveff/rhel-bootc-plus-flightctl/blob/main/flightctl/proxied-flightctl-container-reposync.sh




