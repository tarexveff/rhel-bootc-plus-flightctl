# Intention

This repository is intended to hold artifacts for creating RHEL Image Mode images 
that will be used to image edge devices managed by FlightCtl (aka Red Hat Edge Manager).
The repo also contains artifacts for creating a FlightCtl server (both connected and airgapped).
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
