print("Hello world!")

x = "Hello world!"
print(x)

x = 1 + 1
print(x)

x = "1" + "1"
print(x)

# This is a comment
# Comments are ignored by the Python runtime

'''This is a multi-line string.
   It is often used for multi-line comments, but such use should be carefully reviewed
   This is not ignored by the Python runtime'''

x = '''This is a multi-line string.
   It is often used for multi-line comments, but such use should be carefully reviewed
   This is not ignored by the Python runtime'''
print(x)

myvariable = 'ateam'
# print() is a function
print(myvariable)

# Be consistant to avoid bugs, and for readability
myothervariable = "knight rider"
print(myothervariable)

# Loops
f = open("shows.txt", "r")

for shows in f:
    print(shows)

f.close()

# Print implicitly appends a new line
f = open("shows.txt", "r")

for shows in f:
    shows = shows.rstrip("\n")
    print(shows)

f.close()



# Lists

f = open("shows.txt", "r")

tv = []

for shows in f:
    shows = shows.strip()
    tv.append(shows)

f.close()

print(tv)
print(len(tv))

for show in tv:
    if show[0] == "T":
        print(show)


# Write file
f = open("names.txt", "w")

while True:
    participant = input("Name: ")
    if participant == "quit":
        print("Quitting...")
        break

    score = input("Score: ")
    f.write(participant + "," + score + "\n")
f.close()



# Create dictionary from file
f = open("names.txt", "r")

participants = {}

for line in f:
    entry = line.strip().split(",")
    participant = entry[0]
    score = entry[1]
    participants[participant] = score
    print(participant + ":" + score)

f.close()

print(participants)








value = '8'

if value == '7':
    print('The value is 7')
elif value == '8':
    print('The value is 8')
else:
    print('The value is not one we''re looking for')

print('Finished!')





import random 

roll = 0
count = 0

print('First person to roll a 5 wins!')
while roll != 5:
  name = input('Enter a name, or \'q\' to quit:  ' )

  if name.strip() == '':
    continue

  if name.strip() == 'q':
      break
  
  count = count + 1
  roll = random.randint(1, 5)
  print(f'{name} rolled {roll}')
else:
    print(f'{name} Wins!!!')

print(f'You rolled the dice {count} times.')




# Creating functions
def timestwo(x):
    return x * 2

def squared(x):
    return x * x

def power(x,y):
    return x ** y


print(timestwo(25))
print(squared(9))
print(power(5,3))


# Useful modules
import Calendar
import OS # Allows interactions with the OS. Depends on OS
import Random # Generate random numbers or letters
import Tkinter # Use to build a GUI interface
# import Pygame # Use to develop games
# import Math # Advanced mathematical functions - e.g. mass-energy equivalence
