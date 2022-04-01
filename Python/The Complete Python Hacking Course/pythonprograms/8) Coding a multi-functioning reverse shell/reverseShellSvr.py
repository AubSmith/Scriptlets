#!/user/bin/python

import socket
from termcolor import colored

# Create Server

# Create TCP IPv4 socket object
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.set_sock_opt(socket.SOL_Socket, socket.SO_REUSEADDR, 1)

# IP and port to bind to
sock.bind(("192.168.1.10", 54321))
# Set number of listerners
sock.listen(5)

print(colored("[+] Listening for inbound connections."))

source, ip = sock.accept()
print(colored("[+] Connection established from: %s" % str(ip)))