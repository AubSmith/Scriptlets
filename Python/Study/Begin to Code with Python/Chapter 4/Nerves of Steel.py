print('''
Welcome to Nerves of Steel

Everybody stand up
Stay standing as long as you dare
Sit down just before you think the tile will end
''')

import time
import random

stand_time = random.randint(5, 20)

print('Stay standing for', stand_time, 'seconds.')

time.sleep(stand_time)

print('*****TIME UP*****')