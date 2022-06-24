#! /usr/bin/python

# Find other hosts on the network!

import sys
from datetime import datetime

try:
    from logging import getLogger, ERROR
    getLogger('scapy.runtime').setLevel(ERROR)
    from scapy.all import *
    conf.verb = 0
except ImportError:
    print('[!] Failed to import Scapy')
    sys.exit(1)

interface = "wifi"
passive = True
range = range
discovered_hosts = {}
filter = 'arp'
# starttime = datetime.now()

# Confirm if host is in dictionary. If not add it
def passive_handler(self, pkt):
    try:
        if not pkt[ARP].psrc in discovered_hosts.keys():
            print("%s - %s" %(pkt[ARP].psrc, pkt[ARP].hwsrc)) # Get IP & MAC
            discovered_hosts[pkt[ARP].psrc] = pkt[ARP].hwsrc
    except Exception:
        return
    except KeyboardInterrupt:
        return

def passive_sniffer(self):
    if not self.range:
        print("[*] No range provided, sniffing all ARP traffic")
    else:
        self.filter += ' and (net %s)' %(range)
    print("[*] Sniffing started on %s\n" %(interface))
    try:
        sniff(filter=filter, prn=passive_handler, store=0)
    except Exception:
        print("\n[!] An unknown error occured")
        return
    print("\n[*] Sniffing Stopped")
    # self.duration = datetime.now() - self.starttime
    # print("[*] Time lapsed: %s" %(self.duration))

def active_scan(self):
    print("[*] Scanning for hosts..."),
    sys.stdout.flush()
    try:
        # Use scapy to send ARP requests in range and store results
        ans = srp(Ether(dst="ff:ff:ff:ff:ff:ff")/ARP(pdst=self.range), timeout=2, iface=self.interface, inter=0.1)[0]
    except Exception:
        print("[FAIL]")
        print("[!] An unknown error occured")
        return
    print("[DONE]\n[*] Displaying Discovered HOSTS:\n")
    # Iterate over discovered hosts
    for snd, rcv in ans:
        self.discovered_hosts[rcv[ARP].psrc] = rcv[ARP].hwsrc
        print("%s - %s" %(rcv[ARP].psrc, rcv[ARP].hwsrc))
    print("\n[*] Scan complete")
    # self.duration = datetime.now() - self.starttime
    # print("[*] Scan duration: %s" %(self.duration))
    return

def output_results(self, path):
    print("[*] Writing results to file..."),
    try:
        with open(path, 'w') as file:
            file.write("Discovered hosts: \n")
            for key, val in self.discovered_hosts.items():
                file.write("%s - %s \n" %(key, val))
            file.write("\nScan Duration: %s\n" %(self.duration))
        print("[DONE]\n[*] Successfully written to %s" %(path))
        return
    except IOError:
        print("\n[!] Failed to write to file")
        return

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description="ARP network enumeration tool")
    parser.add_argument('-i', '--interface', help='Network interface to scan on', action='store', dest='interface', default=False)
    parser.add_argument('-r', '--range', help='Range of IPs in CIDR notation', action='store', dest='range', default=False)
    parser.add_argument('--passive', help='Enable passive mode [Sniff only - no packets sent]', action='store', dest='passive', default=False)
    parser.add_argument('-o', help='Output scan results to file', action='store', dest='file', default=False)
    args = parser.parse_args()
    if not args.interface:
        parser.error('Network interface not provided')
    elif (not args.passive) and (not args.range):
        parser.error("No range specified for active scan")
    else:
        pass
