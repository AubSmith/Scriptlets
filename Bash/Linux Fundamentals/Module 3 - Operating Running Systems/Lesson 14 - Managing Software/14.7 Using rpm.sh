rpm -qf /my/file
rpm -ql mypackage
rpm -qpc mypackage.rpm
rpm -qp --scripts mypackage.rpm

rpm -qf /usr/bin/passwd
rpm -ql passwd
rpm -qc passwd
yumdownloader nc
rpm -qpl nmap...rpm
rpm -qp --script httpd...rpm

# Install
# i=install
# v=verbose
# h=print marks and installed/uninstalled
rpm -ivh <package name>

# Check dependencies
# q=query
# p=list capabilities package provides
# R=list package dependencies
rpm -qpR <package name>

# List all files in package
rpm -ql <package name>

rpm -qf <package name>

rpm -qa | grep artifactory

# Remove package
rpm -e <package name>

# Uppack RPM to current directory - handy to see what changes
rpm2cpio jfrog-artifactory.rpm | cpio -idmv