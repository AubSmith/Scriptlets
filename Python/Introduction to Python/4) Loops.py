names = ["Alice","Bob","Cassie","Diane","Ellen"]
for name in names:
    print(name)

names = ["Alice","Bob","Cassie","Diane","Ellen"]
for twits in names:
    print(twits)

for word in names:
    print("Hello " + word)

name = "Alice"
name[0]
name[0] in ["A","E","I","O","U"] # Same as;
name[0] in "AEIOU"

for name in names:
    if name[0] in "AEIOU":
        print(name + " starts with a vowel")

vowel_names = []
for name in names:
    if name[0] in "AEIOU":
        vowel_names.append(name)

vowel_names


prices = [1.5, 2.35, 5.99, 16.49]
total = 0
for price in prices:
    total = total + price

total

sum(prices)
