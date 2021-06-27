# Making Choices: booleans, if/elif/else, compound conditionals.

True

type(True)
type(False)

0==0

0==1

0!=1
"a" == "A"

x=4
x

x==4

1>0
2>=3

-1 < 0

.5 <= 1

"H" in "Hello"

"X" not in "Hello"

True

# if
if 6 > 5:
    print ("Six id greater than 5")

if 0 > 2:
    ("Print zero is greater than two")

if "banana" in "bananarama":
    print("I miss the 80s")

sister = 15
brother =12
if sister > brother:
    print("Sister is older than brother")
else:
    print("Brother is older than sister")

sister = 12
brother =15
if sister > brother:
    print("Sister is older than brother")
else:
    print("Brother is older than sister")

x=1
x > 0 and x < 2

1 < 2 and "x" in "abc"

"a" in "hello" or "e" "hello"


1 <= 0 or "a" not in "abc"

temp = 32
if temp > 60 and temp < 75:
    print("Nice and cosy")
else:
    print("Too extreme for me")

hour = 11
if hour < 7 or hour > 23:
    print("Go away!")
    print("I'm sleeping!")
else:
    print("Welcome!")
    print("Everything is 50% off today")


sister = 15
brother =15
if sister > brother:
    print("Sister is older than brother")
elif sister == brother:
    print("Same age.")
else:
    print("Brother is older than sister")