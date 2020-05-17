print('Hello World!')

help(print)

x = 1
print(type(x))

x = 1.0
print(type(x))

x = True
print(type(x))

X = 'This is a string'
print(x)
print(type(x))

y = 'This is also a string'

x = 'Hello' + ' ' + 'World!'
print(x)

# This is a comment

x = 1   # the rest of the line is a comment
# ... and this is a 3rd comment
text = "# But this isn't a comment because it's a string literal and in quotes."

# This is a comment
# that crosses multiple lines

name = input('Enter your name:')
print(name)

print('What is your name?')
name = input()
print(name)

x = input('Enter a number: ')
print(type(x))

x = int(input('Enter a number:'))
print(type(x))

x = 5
print('The number is ' + str(x))