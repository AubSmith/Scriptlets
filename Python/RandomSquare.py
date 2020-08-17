# generate random integer values
from random import seed
from random import randint
# seed random number generator
seed(1)
# generate some integers
for _ in range(10):
    random = randint(0, 99)
    value = pow(random,2)
    print(value)