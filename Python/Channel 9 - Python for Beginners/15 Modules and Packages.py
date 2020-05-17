# Create module: helpers.py
def display(message, is_warning=False):
    if is_warning:
        print('Warning!!!')
    print(message)



# Import module as namespace
import helpers
helpers.display('Not a warning')



# Import all into current namespace
from helpers import *
display('Not a warning')



# Import specific items into current namespace
from helpers import display
display('Not a warning')



# PIP

# Install individual package
pip install colorama

# Install from list of packages
pip install -r requirements.txt

# requirements.txt
colorama