def get_initial(name, force_uppercase):
    if force_uppercase:
        initial = name[0:1].upper()
    else:
        initial = name[0:1]
    return initial

first_name = input('Enter your first name: ')
first_name_initial = get_initial(first_name, False)

print('Your initials are: ' \
    + first_name_initial)



# Set default parameter value
def get_initial2(name, force_uppercase=True):
    if force_uppercase:
        initial = name[0:1].upper()
    else:
        initial = name[0:1]
    return initial

first_name = input('Enter your first name: ')
first_name_initial = get_initial2(first_name)

print('Your initials are: ' + first_name_initial)



# Set named notation
def get_initial3(name, force_uppercase):
    if force_uppercase:
        initial = name[0:1].upper()
    else:
        initial = name[0:1]
    return initial

first_name = input('Enter your first name: ')
first_name_initial = get_initial3(force_uppercase=True, \
                                name=first_name)

print('Your initials are: ' + first_name_initial)