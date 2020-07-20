# print(type('Hello world'))
# print(type(7))

# print(type(True))
# print(type(False))

# print(type('True'))
# print(type('False'))

# print(type(bool('True')))
# print(type(bool('False')))

# # Empty string = False
# print(bool(''))
# # Non-empty string = True
# print(bool(' '))
# print(bool('Hello world!'))

# # None 0 integers = True
# print(bool(7))
# print(bool(1))
# # 0 = False
# print(bool(0))
# print(bool(-1))

# # 2 + 1 = 3  = False
# # 1 + 1 = 2  = True

# # == evaluates two values for equality
# # = False
# print(1 + 1 == 3)

# # = True
# print(1 + 1 == 2)

# print(3 == 4)
# print(3 != 4)

# print(3 > 4)
# print(3 < 4)
# print(3 >= 4)
# print(3 <= 4)

first_number = 5
second_number = 0
true_value = True
false_value = False

if first_number > 1 and first_number < 10:
    print('The value is between 1 and 10.')

if first_number > 1 or second_number < 1:
    print('At least one value is greater than 1')

print(not true_value)
print(not false_value)

if not first_number > 1 and second_number < 10:
    print('Both values pass the test')
else:
    print('Both values do NOT pass the test')