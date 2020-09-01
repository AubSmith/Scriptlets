# Create a list of common moon rocks
rockTypes = ["basalt", "highland", "breccia"]
rockTypes

# A list with rock names and the number of that rock found
rockTypeAndCount = ["basalt", 1, "highland", 2.5, "breccia", 5]
rockTypeAndCount

rockTypes.append("soil")
rockTypes

# We can also delete items from the end of a list by calling the .pop() function. We'll now delete soil from the rock types list.
rockTypes.pop()
rockTypes

rockTypes[1]

# We can also change a specific value in the list at a specific point by coding.
rockTypes[2] = "soil"
rockTypes

numRocks = 15
print(numRocks)

numBasalt = 4
print("The number of Basalt rocks found:", numBasalt)

date = "February 26"
numRocks = 15
print("On", date, "number of rocks found:", numRocks)