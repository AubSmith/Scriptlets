country = input('Which country do you live in? ')


if country.capitalize == 'Canada':
    province = input('Which province do you live in? ') 
    if province.capitalize in('Alberta', 'Nunavut', 'Yukon'):
        tax = 0.05
    elif province == 'Ontario':
        tax = 0.13
    else:
        tax = 0.15
else:
    tax = 0.0