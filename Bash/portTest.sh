## check for tcp port ##
## need bash shell ##
(echo >/dev/tcp/{host}/{port}) &>/dev/null && echo "open" || echo "close"
(echo >/dev/udp/{host}/{port}) &>/dev/null && echo "open" || echo "close"
(echo >/dev/tcp/www.cyberciti.biz/22) &>/dev/null && echo "Open 22" || echo "Close 22"
(echo >/dev/tcp/www.cyberciti.biz/443) &>/dev/null && echo "Open 443" || echo "Close 443"


# On target
ss -tulwn

ss -tl

# Find LDAP hosts
host -t srv _/ldap.tcp.domain.com