def greeting():
    print("Hello")

greeting()


def greeting(name):
    print("Hello " + name)

greeting("Aubs")


prices = [1.5, 2.75, 16.49, 9.90, 3.05]
total = 0
for number in prices:
    total = total + number


def sum(numbers):
    total = 0
    for number in prices:
        total = total + number
    return total

sum(prices)
grocery_total = sum(prices)

grocery_total



def vowel(word):
    return word[0] in "AEIOU"

vowel("Alice")
vowel("Max")


names = ["Alice","Bob","Cara", "Dan", "Edith"]

def filter_to_vowel_words(word_list):
    vowel_words = []
    for word in word_list:
        if vowel(word):
            vowel_words.append(word)
    return vowel_words

filter_to_vowel_words(names)

v =  filter_to_vowel_words(names)