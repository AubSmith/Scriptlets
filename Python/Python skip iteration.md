To skip an instance of an iteration use continue

for house in houses:
    try:
        if house == 'red':
            continue
        print(f'House colour is {house}.') Will not print red houses.