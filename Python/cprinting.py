#!/usr/bin/python

from termcolor import cprint, colored

word = "safe"
cprint(f'{"dangerous".upper():~^20}\n', 'red', attrs=['reverse', 'blink'], end='')
cprint(f'{word: ^20}\n'.upper(), 'green', attrs=['reverse', 'blink'], end='')
print(f"I have been", colored(f"{word}", 'cyan'), "for 30 seconds !! - lets sync now...")