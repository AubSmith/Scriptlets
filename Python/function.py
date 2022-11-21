
usage = '''
USAGE: ./function.py

Select one of the following options to be run - enter numeric value;
1 - Function1
2 - Function2
3 - Quit

'''



# Logic to handle functions
def function_support():

    # Loop through menu options
    while True:
        # Print options
        print(f'''
        
        Select one of the following options:
        1 - Function1
        2 - Function2
        3 - Function3
        4 - Quit
    
        ''')
    
        try:
            option = input('Please enter your option: ')

            fav_superhero = 'DareDevil'
            fav_villian = 'Black Mask'
    
            if option == '1':
                superhero = 'Batman'
                universe = 'DC'

                function1(superhero, universe)
                
            elif option == '2':
                superhero = 'Spider-Man'
                function2(superhero)
            
            elif option == '3':
                function3(fav_superhero, fav_villian)
        
            else:
                option == '4'
                print('Goodbye')

                # Exit function
                return
    
        except:
            print(f'''Please select a valid numeric option. 
    
                {usage}
                
                ''')

def function3(fav_superhero, fav_villian):
    print(f'My favourite superhero is: {fav_superhero}')
    print(f'My favourite villian is: {fav_villian}')

def function2(superhero):
    print('Inside function 2')
    print(superhero)

    return

def function1(superhero, universe):
    print(f'{superhero} in {universe}')
    print('Calling function 2')
    function2(superhero)

    print('Back in function 1')

function_support()
