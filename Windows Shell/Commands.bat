sc query spooler

# Read file in cmd shell
more filename.txt
type filename.txt

# Logged in user
query user /server:computername

# User account details
net user esmith /domain
net user %username% /domain
net user %username%admin /domain

# User group membership
whoami /groups /fo list |findstr /:c "Group Name:" | sort

whoami /all

# File extension associations
assoc

# Securely dispose of disk
cipher

# Driver info
driverquery

# Compare files
fc

# System info
systeminfo

# System file checker
sfc

# Tasks
tasklist
tasklist -v

# Kill Tasks
taskkill /?
taskkill /pid 1230 /pid 1241 /pid 1253

chkdsk

# Change cmd prompt
prompt


qwinsta

echo "Hello World" > test.txt
type test.txt

# Query ADDC bind
nltest /dsgetdc:

nltest.exe /lsaqueryfti:wayneent.com

# Verify Trust
netdom trust wayneent.com /domain:waynecorp.com /invoketrustscanner`

# Clear Kerberos cache
Get-WmiObject -ClassName Win32_LogonSession -Filter "AuthenticationPackage != 'NTLM'" | ForEach-Object {[Convert]::ToString($_.LogonId, 16)} | ForEach-Object { klist.exe purge -li $_ }

# Set SPN
setspn -s http/federation.service.waynecorp.com\gbladfsdsa

# Task scheduler
schtasks /create

# DNS
# Flush cache
ipconfig /flushdns

# SOA
nslookup -type=soa wayneent.com

# Lookups
nslookup server.wayneent.com # Forward
nslookup 192.168.1.100 # Reverse

nslookup # Interactive mode
# > set q=ns
# > dns.wayneent.com
# > set q=mx
# > dns.wayneent.com
# > set q=soa
# > dns.wayneent.com
# > set debug
# > server1.wayneent.com
