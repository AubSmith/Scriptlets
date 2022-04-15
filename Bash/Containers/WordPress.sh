# cgroups In kernel allow processes to be tagged with namespace. 
# Namespace operate in contained namespace

sudo dnf install podman

# Allow user run container to spawn sufficient processes 
touch /etc/subuid
echo esmith:200000:165536  >> /etc/subuid

touch /etc/subgid
users:200000:165536  >> /etc/subgid

# Confirm permitted namespaces/user
sysctl --all --pattern user_namespaces

# Confirm ability to manage at least 28,000 namespaces
/etc/sysctl.d/userns.conf
#  user.max_user_namespaces=28633

podman run --name mypress -p 8080:80 -d wordpress

# Browse to localhost:8080

podman stop mypress
podman rm mypress

# Run pod
podman pod create --name wp_pod --publish 8080:80

podman pod list

# Launch DB
podman run --detach \
--pod wp_pod \
--restart=always \
-e MYSQL_ROOT_PASSWORD="badpassword0" \
-e MYSQL_DATABASE="wp_db" \
-e MYSQL_USER="tux" \
-e MYSQL_PASSWORD="badpassword1" \
--name=wp_db mariadb

# Attach to same pod
podman run --detach \
--restart=always --pod=wp_pod \
-e WORDPRESS_DB_NAME="wp_db" \
-e WORDPRESS_DB_USER="tux" \
-e WORDPRESS_DB_PASSWORD="badpassword1" \
-e WORDPRESS_DB_HOST="127.0.0.1" \
--name mypress wordpress

# Browse to localhost:8080