# Egg-timer

import time

time_text = input('Enter the cooking time in seconds: ')
time_int = int(time_text)

print('Start boiling')

time.sleep(time_int - 5)

print('Almost there, get your spoon ready!')

time.sleep(5)

print('Cooked!')