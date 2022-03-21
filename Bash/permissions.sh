# https://www.linuxnix.com/suid-set-suid-linuxunix/

chmod -R u+rwx folder

setfacl -R -m u:username:rx folder

setfacl -dm g:groupname:rx folder
setfacl -m g:groupname:rx folder/*