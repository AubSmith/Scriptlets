message = str.capitalize('first message')
print(message)

message = 'second message'.capitalize()
print(message)

message = 'third message'
print(message.capitalize())

message = 'hello world'
print(message.lower())
print(message.upper())

message = message.title()
print(message)
print(message.swapcase())

location = 'Mississippi'
print(location.count('s'))

print(len('How many letters in this string?'))

message = 'racecar'
print(message.startswith('r'))
print(message.startswith('a'))
print(message.startswith('ra'))

print(message.endswith('r'))
print(message.endswith('a'))
print(message.endswith('ar'))

message = 'The quick brown fox jumps over the lazy dog'
print(message.find('q'))
print(message.find('t'))
print(message.find('T'))

message = '     middle     '
print('.' + message.lstrip() + '.')
print('.' + message.rstrip() + '.')
print('.' + message.strip() + '.')

message = 'brevity is the essence of wit'
message = message.replace('essence', 'soul')
print(message)

message = 'howdy'
print(message.rjust(20))
print(message.rjust(20, '-'))
print(message.ljust(20))
print(message.ljust(20, '-'))