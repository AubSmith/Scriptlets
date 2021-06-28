import scrabble

# Print all words containing 'uu' .
for word in scrabble.wordlist:
    if "uu" in word:
        print(word)



import scrabble

# Print all words containing 'uu' .
for word in scrabble.wordlist:
    if "uu" in word and "ee" in word:
        print(word)


import scrabble

# Print all words containing 'uu' .
for word in scrabble.wordlist:
    if "q" in word and "u" not in word:
        print(word)


import scrabble

letters = "abcdefghijklmnopqrstuvwxyz"

def has_double(letter):
    for word in scrabble.wordlist:
        if letter + letter in word:
            return True
    return False

for letter in letters:
    if not has_double(letter):
        print(letter + " never appears as double")



import scrabble

vowels = "aeiou"

def has_all_vowels(word):
    for vowel in vowels:
        if vowel not in word:
            return False
    return True

counter = 0
for word in scrabble.wordlist:
    if has_all_vowels(word):
        counter = counter + 1
        print(word)
print(counter)