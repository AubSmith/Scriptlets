# List - can be anything
names = ['Christopher', 'Susan']
scores = []
# Add new item to end
scores.append (98)
scores.append (99)

print(names)
print(scores)
# Collections are zero-indexed
print(scores[1])

# Array - must be same numeric data type
from array import array
scores = array('d')
scores.append (97)
scores.append (98)
print(scores)
print(scores[1])

names = ['Susan', 'Christopher']
print(len(names)) # Get number of items
names.insert(0, 'Bill') # Insert before index
print(names)
names.sort()
print(names)


names = ['Susan', 'Christopher', 'Bill', 'Justin']
presenters = names[1:3] # Start and end index, up to not including
print(names)
print(presenters)


# Dictionaries - key/value pairs
person = {'first' : 'Christopher'}
person['last'] = 'Harrison'
print(person)
print(person['first'])

christopher = {}
christopher['first'] = 'Christopher'
christopher['last'] = 'Harrison'

Susan = {}
Susan ['first'] = 'Susan '
Susan ['last'] = 'Ibach'

people = []
people.append(christopher)
people.append(Susan)
people.append({
    'first' : 'Bill', 'last' : 'Gates'
})
print(people)