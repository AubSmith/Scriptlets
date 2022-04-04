On Linux


# Part 1
# Create Packet
scapy

IPlayer = IP()
IPLayer
IPlayer.show()
TCPlayer = TCP()
pkt = IPlayer/TCPlayer
pkt.show()
pkt.src = "192.168.1.100"
pkt.dst = "192.168.1.5"
pkt.show()
send(pkt)

# Part 2
pkt2 = Raw()
pkt = pkt/pkt2
pkt.show()
pkt.load = "This is a plain text message"
send(pkt)
