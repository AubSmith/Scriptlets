oc whoami
oc whoami -c # Show context
oc whoami --show-console # Show Web console URL


oc help

oc status
oc status --suggest
oc get all # List all resources in a namespace
oc describe pod parksmap-8cb4d64c5-kh2ls

oc get serviceaccount


oc login -u developer https://api.crc.testing:6443

# Typically Pod, Service, ReplicaSet and Deployment resources used together

oc get pods

oc get pod parksmap-8cb4d64c5-kh2ls -o yaml

oc get services

oc get service parksmap -o yaml

# Labels are just key/value pairs. 
# Any Pod in this Project that has a Label that matches the Selector will be associated with the Service.
# To see this in action, issue the following command:
oc describe service parksmap

# Deployment (D) defines how something should be deployed
oc get deployment

# ReplicationSet - Ensure the desired number of Pods (replicas) are in existence
oc get rs

oc scale --replicas=2 deployment/parksmap

oc get rs

oc describe svc parksmap

oc get endpoints parksmap

oc delete pod parksmap-8cb4d64c5-gcqsh && oc get pods

oc scale --replicas=1 deployment/parksmap

# Creating a route
oc get routes
oc get services
oc create route edge parksmap --service=parksmap
oc get route

# View logs
oc get pods
oc logs parksmap-1-hx0kv
oc logs -f parksmap-1-hx0kv

# Set permissions
oc project test
oc policy add-role-to-user view -z default
oc rollout restart deployment/parksmap

# Connect to container
oc exec parksmap-65c4f8b676-fxcrq -- ls -l /parksmap.jar # Execute command remotely OR
oc get pods
oc rsh parksmap-65c4f8b676-fxcrq
ls / # OR
oc rsh parksmap-65c4f8b676-fxcrq whoami
oc rsh parksmap-65c4f8b676-fxcrq bash -c pwd

# Debug container
oc debug <pod_name>

# S2I builds
oc get builds
oc logs -f builds/nationalparks-1

oc get routes

# Database
oc create -f https://raw.githubusercontent.com/openshift-labs/starter-guides/ocp-4.8/mongodb-template.yaml -n aubreysmith-dev # Create template
oc import-image mongodb:3.6 --from=registry.access.redhat.com/rhscl/mongodb-36-rhel7 --confirm
# oc import-image postgres:latest docker-remote.artifactory.service.waynecorp.com --confirm

oc label dc/mongodb-nationalparks svc/mongodb-nationalparks app=workshop component=nationalparks role=database --overwrite

oc describe route nationalparks

oc label route nationalparks type=parksmap-backend

# Use Go template to filter pods
# https://cloud.redhat.com/blog/customizing-oc-output-with-go-templates
oc get pods
oc get pods --template '{{range .items}}{{.metdata.name}}{{"\n"}}{{end}}'
oc get pods --template '{{range .items}} {{if eq .status.phase "Running"}} {{.metdata.name}}{{"\n"}}{{end}}{{end}}'
oc get pods --template '{{range .items}} {{if eq .status.phase "Running"}} {{- .metdata.name}}{{"\n"}}{{end}}{{end}}'
oc get pods --template '{{- range .items -}} {{if eq .status.phase "Running"}} {{.metdata.name}}{{"\n"}}{{end}}{{end}}'
oc get pods --template '{{- range .items -}} {{if eq .status.phase "Running"}} {{- .metdata.name}}{{"\n"}}{{end}}{{end}}'
oc get pods --template '{{range .items}} {{if eq .status.phase "Running"}} {{.metdata.name}} {{.status.phase}} {{"\n"}}{{end}}{{end}}'


# To update
oc new-app postgresql-13:1-53 -e POSTGRESQL_USER=user -e POSTGRESQL_DATABASE=db -e POSTGRESQL_PASSW)RD=password

oc expose service/postgresql-13

oc project # Display the current project
oc projects # List existing projects
oc project list # List existing projects
oc project projectname # Switch to a specific project

# View current settings
oc config view

oc scale dc <resource_name> --replicas=<count> 
oc autoscale deployment <resource_name> --min=2 --max=4 --cpu-percent=80% # Scale the application between 2 and 4 pods with a target CPU utilization of 80%

oc delete all -l app=<app_name> # Delete all resources of the application
oc delete pod <pod_name> # Delete all pod

oc logout