price = input('How much did you pay? ')
price = float(price)
if price >= 1.00:
    tax = .07
else:
    tax = 0
print('Tax rate is: ' + str(tax))



# String comparisons are case sensitive
country = 'CANADA'
if country == 'Canada':
    print('Oh look, a Canadian')
else:
    print('You are not from Canada')

country = 'CANADA'
if country.capitalize() == 'Canada':
    print('Oh look, a Canadian')
else:
    print('You are not from Canada')