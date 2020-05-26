'''
This is a multi-line string literal which can be used to span multiple lines.
As this can be ignored by the program logic it can be used for multi-line commenting.
'''

# Create class
class MyClass:
    x = 5

p0 = MyClass()
print(p0.x)


# Create object
class Person:
# Note: The self parameter is a reference to the current instance of the class, and is used to access variables that belong to the class.
    def __init__(self, name, age):
        self.name = name
        self.age = age

# Create method
    def myFunc(self):
        print("Hello, my name is " + self.name)

p1 = Person("John", 36)

print(p1.name)
print(p1.age)

# Modify object property
p1.age = 40

# Delete object property
del p1.age

# Delete object
del p1

p1.myFunc()




class Persons:
  def __init__(mysillyobject, name, age):
    mysillyobject.name = name
    mysillyobject.age = age

  def myfunc(abc):
    print("Hello my name is " + abc.name)

p2 = Persons("Steve", 22)
p2.myfunc()
