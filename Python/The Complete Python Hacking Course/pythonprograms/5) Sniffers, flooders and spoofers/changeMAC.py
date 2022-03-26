#!/usr/bin/python

import imp
import subprocess
from termcolor import colored

def change_mac_address(interface, mac):
    subprocess.call(["ifconfig",interface,"down"])
    subprocess.call(["ifconfig",interface,"hw","ether",mac])
    subprocess.call(["ifconfig",interface,"up"])

def main():
    interface = str(input("[*] Select interface: "))
    new_mac_address = input("[*] Enter new MAC address: ")

    before_change = subprocess.check_output("ifconfig",interface)
    change_mac_address(interface, new_mac_address)
    after_change = subprocess.check_output(["ifconfig",interface])

    if before_change == after_change:
        print(colored("[!!] Failed to change MAC address to " + new_mac_address, 'red'))
    else:
        print(colored("[+] MAC address changed to: " + new_mac_address + "on " + interface, 'green'))

main()