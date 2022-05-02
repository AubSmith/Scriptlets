# Set OpenShift project name
export OC_PROJECT=os-project-name

# Set variable for pod labels
export OC_POD_LABEL_APP=$(OC_PROJECT)
export OC_POD_LABEL_ALERT_EMAIL=alert@wayneent.com
export OC_POD_LABEL_SUPPORT_TEAM=Wintel

# Set variables for context
OC_PROD=oc --context $(OC_PROJECT)/oscluster-nz-service-wayneent-com:6443/$(USER)

# Set empty vars for later use
PG_POD_NAME=""
PG_BACKUP_FILE=""
PG_BACKUP_CMD=""
PG_QUERY_CMD=""
PG_RESTORE_CMD=""

# Warn user if no arguments supplied
empty:
	@echo "Don't run the makefile without understanding it."
	@echo "Use make [target] depending on step required."
	@false

delete-db:
	@$(OC_PROD) delete --ignore-not-found=true dc/$(OC_PROJECT)-db-internal
	@$(OC_PROD) delete --ignore-not-found=true svc/$(OC_PROJECT)-db-internal
	@$(OC_PROD) delete --ignore-not-found=true pvc/$(OC_PROJECT)-db-internal
	@$(OC_PROD) delete --ignore-not-found=true secret/$(OC_PROJECT)-db-internal
	@$(OC_PROD) delete --ignore-not-found=true svc/$(OC_PROJECT)-db-external

# Create Postgres DB
create-db:

	# Deploy DB
	@$(OC_PROD) new-app postgresql-persistent \
	-p DATABASE_SERVICE_NAME=$(OC_PROJECT)-db-internal \
	-p POSTGRESQL_USER=$(POSTGRESQL_USER) \
	-p POSTGRESQL_PASSWORD=$(POSTGRESQL_PASSWORD) \
	-p POSTGRESQL_DATABASE=$(OC_PROJECT) \
	-p VOLUME_CAPACITY=1Gi \
	-p POSTGRESQL_VERSION=10-el8 \
	--name=$(OC_PROJECT)

	# Wait for deployment to complete
	@$(OC_PROD) rollout status dc $(OC_PROJECT)-db-internal -w

	# Copy DB custom config
	$(eval PG_POD_NAME=`oc get pods --template '{{range .items}} {{if eq .status.phase "Running"}} {{.metadata.name}}{{"\n"}}{{end}}{{end}}'`)
	@$(OC_PROD) cp config/postgresql.conf \
	$(PG_POD_NAME):/varl/lib/pgsql/data/userdata/postgresql.conf
	@$(OC_PROD) cp config/custom-postgresql.conf \
	$(PG_POD_NAME):/varl/lib/pgsql/data/userdata/custom-postgresql.conf

	# Restart to apply new config
	@$(OC_PROD) delete pod $(PG_POD_NAME)

	# Expose with public loadbalanced IP once deployed
	@$(OC_PROD) expose dc $(OC_PROJECT)-db-internal --name=$(OC_PROJECT)-db-external --port=5432 --type=LoadBalancer

	# Configure required project access
	@$(OC_PROD) adm policy add-role-to-user admin esmith -n $(OC_PROJECT)

	# Confirm created database details
	@echo Postgres DB instance successfully deployed to project!
	@echo
	@echo You can confirm in the OpenShift dashboard here:
	@echo		Production: https://console.openshift.service.wayneent.com/console/project/$(OC_PROJECT)

	@echo You can connect to the database using these details:
	@echo		 Username: $(POSTGRESQL_USER)
	@echo		 Password: $(POSTGRESQL_PASSWORD)
	@echo	Database name: $(OC_PROJECT)
	@echo	 Internal URL: postgresql://$(OC_PROJECT)-db-internal:5432/
	@echo	  External IP: `$(OC_PROD) get svc $(OC_PROJECT)-db-external -o json | jq ".spec.externalIPs" -c`

# Update current DB config
update-db:

	# Copy DB custom config
	$(eval PG_POD_NAME=`oc get pods --template '{{range .items}} {{if eq .status.phase "Running"}} {{.metadata.name}}{{"\n"}}{{end}}{{end}}'`)
	@$(OC_PROD) cp config/postgresql.conf \
	$(PG_POD_NAME):/varl/lib/pgsql/data/userdata/postgresql.conf
	@$(OC_PROD) cp config/custom-postgresql.conf \
	$(PG_POD_NAME):/varl/lib/pgsql/data/userdata/custom-postgresql.conf

	# Restart Postgres to apply updated config
	@$(OC_PROD) delete pod $(PG_POD_NAME)

	# Wait for new pod to come up
	@sleep 5
	$(eval PG_POD_NAME=`oc get pods --template '{{range .items}} {{if eq .status.phase "Running"}} {{.metadata.name}}{{"\n"}}{{end}}{{end}}'`)
	@echo "New pod starting: $(PG_POD_NAME)"

# Query running DB using sql script
query-db:

	# Find running pod and return just the name
	$(eval PG_POD_NAME=`oc get pods --template '{{range .items}} {{if eq .status.phase "Running"}} {{.metadata.name}}{{"\n"}}{{end}}{{end}}'`)
	@echo "Running pod is: ${PG_POD_NAME}"
	@echo

	# Copy query to running pod
	@$(OC_PROD) rsync queries ${PG_POD_NAME}:/var/tmp/
	@echo "Script successfully copied."
	@echo

	# Construct terminal command to run script non-interactively
	@$(eval PG_BACKUP_CMD="psql -d ${OC_PROJECT} -U ${POSTGRESQL_USER} -a -f /var/tmp/queries/example.sql")

	# Run psql command to execute script
	@echo "Executing the script."
	@$(OC_PROD) rsh "${PG_POD_NAME}" bash -c ${PG_QUERY_CMD}

	