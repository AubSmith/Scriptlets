first_name = 'Aubs'
print(first_name)

first_name = 'Aubs'
last_name = 'Smith'
print(first_name + last_name)
print('Hello, ' + first_name + ' ' + last_name)



sentence = 'The dog is named Sammy'

print(sentence.upper())
print(sentence.lower())
print(sentence.capitalize())
print(sentence.count('a'))




first_name = input('What is your first name? ')
last_name = input('What is your last name? ')
print('Hello, ' + first_name.capitalize() + ' ' + last_name.capitalize())



first_name = 'Aubs'
last_name = 'Smith'
print(first_name + last_name)
print('Hello, ' + first_name + ' ' + last_name)

output = 'Hello, ' + first_name + ' ' + last_name
output = 'Hello, {} {}'.format(first_name, last_name)
output = 'Hello, {0} {1}'.format(first_name, last_name)
output = f'Hello, {first_name} {last_name}'
print(output)
