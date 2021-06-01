# Modify environment so that all users have access to the following after logon;

cd /etc/profile.d/
vi wayneent.sh

# - Alias named ipconfig that runs "ip addr show" command
alias ipconfig="ip addr show"

# - A variable named COLOR that has a value set as red
export COLOR=red

# - Ensure the Alias is available in subshell too
alias ipconfig="ip addr show"

# Alias available in subshell by default
# Variables not available in subshell by default