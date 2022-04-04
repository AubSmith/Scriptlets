#!/usr/bin/python

import socket 
from struct import *

# Create HEX string for MAC
def eth_addr(a):
    b = "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x" % (a[0], a[1], a[2], a[3], a[4], a[5])
    return(b)

try:
    s = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, socket.ntohs(0x0003))
except:
    print("[!!] Error creating socket object. Check privileges.")
    exit(0)

while True:
    packet = s.recvfrom(65535)
    packet = packet[0]

# Ethernet Header 14 = src MAC (6 Bytes) + dst MAC (6 Bytes) + protocol (2 Bytes)
    eth_length = 14
    eth_header = packet[:eth_length]

    eth = unpack('!6s6sH', eth_header)
    eth_protocol = socket.ntohs(eth[2])
    print('[+] Destination MAC: ' + eth_addr(packet[0:6]) + ' [+] Source MAC: ' + eth_addr(packet[6:12]) + '[+] Protocol: ' + str(eth_protocol))
  