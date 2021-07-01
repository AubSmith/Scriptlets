# Login username/password
oc login -u=<username> -p=<password> --server=<your-openshift-server> --insecure-skip-tls-verify

# Login oauth
oc login <https://api.your-openshift-server.com> --token=<tokenID>

# Create project
oc new-project <projectname> --description="<description>" --display-name="<display_name>"

# Create application
oc new-app openshift/ruby-20-centos7~https://github.com/<your_github_username>/ruby-ex

# View projects
oc get projects
oc project <project_name>
oc status
