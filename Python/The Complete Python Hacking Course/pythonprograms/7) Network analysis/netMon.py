#!/usr/bin/python

# Linux
from site import check_enableusersite
import socket, os, sys, struct, binascii

sock_create = False
sniff_sock = 0

def analyse_eth_head(data_recv):
    ip_bool = False

    # Extract ethernet header - First 14 Bytes
    eth_hdr = struct.unpack('!6s6sH', data_recv[:14])
    # Extracy src MAC, dst MAC, protocol
    dst_MAC = binascii.hexlify(eth_hdr[0])
    src_MAC = binascii.hexlify(eth_hdr[1])
    prtcl = eth_hdr[2] >> 8
    # Remaining is data
    data = data_recv[14:]

    print("----------ETHERNET HEADER-----------")
    print("Destination MAC: %s:%s:%s:%s:%s:%s" % (dst_MAC[0:2], dst_MAC[2:4], dst_MAC[4:6], dst_MAC[6:8], dst_MAC[8:10], dst_MAC[10:12]))
    print("Source MAC: %s:%s:%s:%s:%s:%s" % (src_MAC[0:2], src_MAC[2:4], src_MAC[4:6], src_MAC[6:8], src_MAC[8:10], src_MAC[10:12]))
    print("Protocol: %hu" % prtcl)
    
    if prtcl == 0x08:
        ip_bool = True
    
    return data, ip_bool

def analyse_ip_hdr(data_recv):
    # Extract first 20 Bytes
    ip_hdr = struct.unpack('!6H4s4s', data_recv[:20])
    # Get first 12 bits for version using logical expression
    ver = ip_hdr[0] >> 12
    ihl = (ip_hdr[0] >> 8) & 0x0f
    tos = ip_hdr[0] & 0x0ff
    tot_len = ip_hdr[1]
    ip_id = ip_hdr[2]
    flags = ip_hdr[3] >> 13
    frag_offset = ip_hdr[3] & 0x1fff
    ip_ttl = ip_hdr[4] >> 8
    ip_pro = ip_hdr[4] & 0x00ff
    checksum = ip_hdr[5]
    src_addr = socket.inet_ntoa(ip_hdr[6])
    dst_addr = socket.inet_ntoa(ip_hdr[7])
    data = data_recv[20:]

    print("----------IP HEADER-----------")
    print("Version: %hu" % ver)
    print("IHL: %hu" % ihl)
    print("ToS: %hu" % tos)
    print("Length: %hu" % tot_len)
    print("ID: %hu" % ip_id)
    print("Flags: %hu" % flags)
    print("Offset: %hu" % frag_offset)
    print("TTL: %hu" % ip_ttl)
    print("Protocol: %hu" % ip_pro)
    print("Checksum: %hu" % checksum)
    print("Source IP: %s" % src_addr)
    print("Destination IP: %s" % dst_addr)

    if ip_pro == 6:
        tcp_udp ="TCP"
    elif ip_pro == 17:
        tcp_udp ="UDP"
    else:
        tcp_udp = "Other"
    
    return data, tcp_udp

def analyse_tcp_head(data_recv):
    # TCP header = 20 Bytes
    tcp_hdr = struct.unpack('!2H2I4H', data_recv[:20])
    src_port = tcp_hdr[0]
    dst_port = tcp_hdr[1]
    seq_num = tcp_hdr[2]
    ack_num = tcp_hdr[3]
    data_offset = tcp_hdr[4] >> 12
    reserved = (tcp_hdr[5] >> 6) & 0x03ff
    tcp_flags = tcp_hdr[4] & 0x03ff
    window = tcp_hdr[5]
    checksum = tcp_hdr[6]
    urg_ptr = tcp_hdr[7]
    # Data = all after first 20 Bytes
    data = data_recv[20:]

    urg = bool(tcp_flags & 0x0020)
    ack = bool(tcp_flags & 0x0010)
    psh = bool(tcp_flags & 0x0008)
    rst = bool(tcp_flags & 0x0004)
    syn = bool(tcp_flags & 0x0002)
    fin = bool(tcp_flags & 0x0001)

    print("----------TCP HEADER-----------")
    print("Source: %hu " % src_port) 
    print("Destination: %hu " % dst_port)
    print("Sequence: %u " % seq_num)
    print("Ack Number: %u " % ack_num)
    print("TCP Flags: ")
    print("URG: %d " % urg)
    print("ACK: %d " % ack)
    print("PSH: %d " % psh)
    print("RST: %d " % rst)
    print("SYN: %d " % syn)
    print("FIN: %d " % fin)
    print("Window Size: %hu " % window)
    print("Checksum: %hu" % checksum)

    return data

    #print("Data Offset: %hu ") %data_offset
    #print("Reserved: %hu ") %reserved
    #print("Urgent Pointer: %s ") %urg_ptr

def analyse_udp_head(data_recv):
    udp_hdr = struct.unpack('!4H', data_recv[:8])
    src_port = udp_hdr[0]
    dst_port = udp_hdr[1]
    length = udp_hdr[2]
    checksum = udp_hdr[3]
    data = data_recv[8:]

    print("----------UDP HEADER-----------")
    print("Source Port: %hu " % src_port)
    print("Destination Port: %hu " % dst_port)
    print("Length: %hu " % length)
    print("Checksum: %hu " % checksum)
    
    return data

def main():
    global sock_create
    global sniff_sock
    if sock_create == False:
        # Create raw ethernet packet object
        sniff_sock = socket.socket(socket.PF_PACKET, socket.SOCK_RAW, socket.htons(0x0003))
        sock_create = True
    # Recieve 2048 Bytes
    data_recv = sniff_sock.recv(2048)
    # Clear screen
    os.system('clear')

    data_recv, ip_bool = analyse_eth_head(data_recv)
    if ip_bool:
        data_recv, tcp_udp = analyse_ip_hdr(data_recv)
    else:
    # If IP header not found drop the packet
        return
    
    if tcp_udp == "TCP":
        data_recv = analyse_tcp_head(data_recv)
    elif tcp_udp == "UDP":
        data_recv = analyse_udp_head(data_recv)
    else:
        # If != TCP/UDP drop the packet
        return

while True:
    main()
