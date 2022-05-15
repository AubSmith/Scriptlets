OpenShift

1) Introduction

Red Hat PaaS container platform

OpenShift Origin - Open source application container platform. Other versions based on this
OpenShift Online - Public application development hosting service
OpenShift Dedicated - Managed private cluster on AWS/GCP
OpenShift Enterprise - On-prem private PaaS

Based on top of Docker containers and the Kubernetes cluster manager, with added developer and operational centric tools.

2) Pre-requisites

Docker

docker run ansible

Docker image = template and is used to create container
Docker container are running instances of images that are isolated and each have own environment and running set of services
Docker file used to create image

Kubernetes

AKA K8s

Container orchestration

# Git URL S2I
https://github.com/openshift-roadshow/nationalparks-katacoda

# Install make
On Windows:
'''winget install GnuWin32.Make'''
'''set PATH=%PATH%;C:\Program Files (x86)\GnuWin32\bin'''

# PowerShell - enable CRC/WSL integration
Get-NetIPInterface | where {$_.InterfaceAlias -eq 'vEthernet (WSL)' -or $_.InterfaceAlias -eq 'vEthernet (Default Switch)'} | Set-NetIPInterface -Forwarding Enabled

# VM IP addresses
get-vm  | Select -ExpandProperty Networkadapters | Select vmname , ipaddress
# OR
get-vm -name crc | Format-list *


# Set URLs in /etc/hosts/

crc daemon