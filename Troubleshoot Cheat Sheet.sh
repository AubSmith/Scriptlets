# Copy support bundle
scp username@remoteHost:/remote/dir/file.txt ./

# GHE
ghe-diagnostics # Create diagnostics file
ssh -p 122 admin@HOSTNAME -- 'ghe-support-bundle -o' > support-bundle.tgz # Create support bundle
ghe-support-upload -f FILE_PATH -t TICKET_ID # Upload support bundle
ghe-repl-status
ghe-license-usage
ghe-user-csv

# Disk
df -h

# CPU
top # q
lscpu

# Memory
cat /proc/meminfo
sudo dmidecode -t memory

