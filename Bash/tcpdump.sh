# Use nohup to ignore hangup (HUP) signal
# nice Commands runs process with lower priority
nohup nice tcpdump -C 200 -w /home/default/tps-reports/rotate.pcap host 192.168.3.10 or host 192.168.3.11 or host 192.168.3.12


# Stop hangup when logging off SSH
# nohup ./myprogram > foo.out 2> foo.err < /dev/null &