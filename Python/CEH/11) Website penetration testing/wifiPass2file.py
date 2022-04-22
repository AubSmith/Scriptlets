#!/usr/bin/python

# wifiPass2File - Extract Wifi passwords in Windows to file.
# Author: Ethan Smith
# Usage: python .\wifiPass2file.py
# Python 3

import subprocess, re

show_pro = "netsh wlan show profile"
wifi = subprocess.check_output(show_pro, shell=True)
wifi_list = re.findall('(?:Profile\s*:\s)(.*)',wifi.decode("UTF-8"))

for wlan in wifi_list:
    try:
        clean_wlan = wlan.strip('\r')
        passwd_find = f"netsh wlan show profile \"{clean_wlan}\" key=clear"
        wifi_result = subprocess.Popen(passwd_find,
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            universal_newlines=True)
        
        out,err=wifi_result.communicate()
        rc=wifi_result.wait()

        with open("wifiPass2file.txt", 'a') as f:
            f.write(f"\n\n{clean_wlan} Return code: {rc} \n\n {out}")
    except err:
       with open("wifiPass2file.txt", 'a') as f:
           f.write(f"Return code: \n\n {rc} \n\n {err}")
    except ValueError as v:
        with open("wifiPass2file.txt", 'a') as f:
           f.write(f"Return code: \n\n {rc} \n\n {v}")
