
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
        3 - Quit
    
        ''')
    
        try:
            option = input('Please enter your option: ')
    
            if option == '1':    
                function1()
                
            elif option == '2':
                function2()
        
            else:
                option == '3'
                print('Goodbye')

                # Exit function
                return
    
        except:
            print(f'''Please select a valid numeric option. 
    
                {usage}
                
                ''')

def function2():
    print('Inside function 2')

    return

def function1():
    print('Calling function 2')
    function2()

    print('Back in function 1')



function_support()
