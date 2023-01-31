psql -h 192.168.1.153 -p 5432 -U sqluser -d artifactory
psql -U sqluser -d artifactory

psql -d myawesomedb -U esmith -a -f /var/tmp/script.sql