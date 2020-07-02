import datetime

def print_time():
    print('Task completed')
    print(datetime.datetime.now())
    print()

firstname = 'Susan'
print_time()

for x in range(0, 10):
    print(x)
print_time()


# OR

from datetime import datetime

def print_time2():
    print('Task completed')
    print(datetime.now())
    print()

firstname = 'Susan'
print_time2()

for x in range(0, 10):
    print(x)
print_time2()



from datetime import datetime

firstname = 'Susan'
print('First name assigned')
print(datetime.now())
print()

for x in range(0, 10):
    print(x)
print('Look completed')
print(datetime.now())
print()



from datetime import datetime

def print_time3(task_name):
    print(task_name)
    print(datetime.now())
    print()

firstname = 'Susan'
print_time3('First name assigned')

for x in range(0, 10):
    print(x)
print_time3('Look completed')



first_name = input('Enter your first name: ')
first_name_initial = first_name[0:1]
last_name = input('Enter your last name: ')
last_name_initial = last_name[0:1]

print('Your initials are: ' + first_name_initial + last_name_initial)



def get_initial(name):
    initial = name[0:1].upper()
    return initial
first_name = input('Enter your first name: ')
first_name_initial = get_initial(first_name)
last_name = input('Enter your last name: ')
last_name_initial = get_initial(last_name)

print('Your initials are: ' + first_name_initial + last_name_initial)



def get_initial2(name):
    initial = name[0:1].upper()
    return initial
first_name = input('Enter your first name: ')
last_name = input('Enter your last name: ')

print('Your initials are: ' \
    + get_initial2(first_name) \
    + get_initial2(last_name))