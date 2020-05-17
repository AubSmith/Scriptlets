print('Would you like to continue?')
to_continue = input()
if to_continue == 'n' or to_continue == 'no':
    print('Exiting')
elif to_continue == 'y' or to_continue == 'yes':
    print('Continuing...')
    print('Complete!')
else:
    print('Please try again and respond with yes or no.')


value = input('Would you like to continue? ')

if value == 'y' or value == 'yes':
    print('Continuing ...')
    print('Complete!')
elif value == 'n' or value == 'no':
    print('Exiting')
else:
    print('Please try again and respond with yes or no.')