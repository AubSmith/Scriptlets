wget https://releases.jfrog.io/artifactory/artifactory-rpms/artifactory-rpms.repo -O jfrog-artifactory-rpms.repo;
sudo mv jfrog-artifactory-rpms.repo /etc/yum.repos.d/;
sudo yum update && sudo yum install jfrog-artifactory-oss

curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/mssql-release.repo
# OR
curl https://packages.microsoft.com/config/rhel/8/prod.repo > /etc/yum.repos.d/mssql-release.repo

sudo su

#Download appropriate package for the OS version
#Choose only ONE of the following, corresponding to your OS version

#Red Hat Enterprise Server 7 and Oracle Linux 7
curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/mssql-release.repo

#Red Hat Enterprise Server 8 and Oracle Linux 8
curl https://packages.microsoft.com/config/rhel/8/prod.repo > /etc/yum.repos.d/mssql-release.repo

exit
sudo yum remove unixODBC-utf16 unixODBC-utf16-devel #to avoid conflicts
sudo ACCEPT_EULA=Y yum install -y msodbcsql18
# optional: for bcp and sqlcmd
sudo ACCEPT_EULA=Y yum install -y mssql-tools18
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
source ~/.bashrc
# optional: for unixODBC development headers
sudo yum install -y unixODBC-devel
# wget SQL JDBC driver https://docs.microsoft.com/en-us/sql/connect/jdbc/microsoft-jdbc-driver-for-sql-server
gzip -d sqljdbc_<version>_<language>.tar.gz
tar -xf sqljdbc_<version>_<language>.tar
mv sqljdbc_<version>_<language>/enu.* /opt/jfrog/artifactory/var/bootstrap/artifactory/tomcat/lib/

sudo vi /var/opt/jfrog/artifactory/etc/system.yaml

# shared:
#   database:
#     type: mssql
#     driver: com.microsoft.sqlserver.jdbc.SQLServerDriver
#     url: jdbc:sqlserver://rhelsvrsql001:1433>;databaseName=artifactory;sendStringParametersAsUnicode=false;applicationName="Artifactory Binary Repository"
#     username: ########
#     password: ########

sudo systemctl start artifactory.service

cat /var/opt/jfrog/artifactory/log/artifactory-service.log
