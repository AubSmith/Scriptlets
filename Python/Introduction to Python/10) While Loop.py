names = ["Alice","Bob","Cara"]
for name in names:
    print("Hello " + name)


for i in [0, 1, 2, 3, 4]:
    print("Hello " + str(i))


counter = 0
while counter < 5:
    print("Hello " + str(counter))
    counter = counter + 1



counter = 0
while True:
    print("Hello " + str(counter))
    counter = counter + 1
    if counter >= 5:
        break



print("Hello human!")

while True:
    user_input = input("> ")
    if user_input == "quit":
        print("Goodbye human!")
        break
    else:
        print(user_input)