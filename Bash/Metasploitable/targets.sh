# Finding hosts with Basic and Digest authentication
# curl
# curl -v HOST:PORT 2> >(grep -o -i -E Unauthorized) > /dev/null

curl -v 192.168.1.6:8080 2> >(grep -o -i -E Unauthorized) > /dev/null
curl -v 192.168.1.6 2> >(grep -o -i -E Unauthorized) > /dev/null

# OR

if [[ "`timeout 3 curl -v HOST 2> >(grep -o -i -E Unauthorized) > /dev/null`" ]]; then
    echo HOST; 
fi

# Wireshark filters
# All authentication sessions (BASIC/DIGEST/NTLM)
http.authorization

# HTTP Basic authentication only
http.authbasic

# HTTP Basic only authentication with specific credentials
http.authbasic == "LOGIN:PASSWORD"

# Crack basic hash (base64 Encoded)
Authorization: Basic bWlhbDoxMjM0

echo STRING | base64 -d
