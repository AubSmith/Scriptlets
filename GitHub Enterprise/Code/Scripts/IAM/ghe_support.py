
# Import required Python modules
import configparser, json, logging, requests, ssl, sys



# Enable logging and configure log filename
logging.basicConfig(filename='ghe_iam.log', level=logging.DEBUG)



usage = '''
USAGE: ./ghe_support.py environment

Envrionment is the environment in which the support activity is to take place. Valid input is either;
prod
test

Select one of the following options to be run - enter numeric value;
1 - Create organization
2 - Add owner to organization
3 - List owners of an organization
4 - list members of an organization
5 - Run IAM rports for all organizations

'''



# Import config from ghe.ini
try:
    config = configparser.ConfigParser()
    config.readfp(open(r'ghe.ini'))
    logging.info('Config file has been read')
except:
    logging.error('Unable to read config file!')
    sys.exit(1)



# Assign variables based on input parameters
# Environment to read config values for - either test or prod
if len(sys.argv) != 2:
    print(usage)
    logging.error(f'Incorrect usage! Please specify and environment when invoking this script. \n {usage}')
    sys.exit(1)
else:
    environment = sys.argv[1]



# Verify valid environment specified
if environment.lower() == 'test':
    environment_url = config.get('Environment', 'Test')
    token = config.get('Token', 'TestToken')
    logging.info(f'Environment set is {environment_url}')
elif environment.lower() == 'prod':
    environment_url = config.get('Environment', 'Production')
    token = config.get('Token', 'ProdToken')
    logging.info(f'Environment set is {environment_url}')
elif environment.lower() == '-h':
    print(usage)
else:
    logging.error('Invalid environment specified. Valid environments are test or prod.')
    sys.exit(1)



# Set REST request header
header = {'Accept-Language': 'application/vnd.github+json',
          'Authorization': f'token {token}'
         }



admin = ''
data = {}

# Logic to handle support functions
def ghe_support():
    # print utility options
    print(f'''
    
    Select one of the following options to be run in the {environment.lower()} environment:
    1 - Create organization
    2 - Add owner to organization
    3 - List owners of an orgaization
    4 - List members of an organization
    5 - Run IAM reports for all organizations

    ''')

    option = input('Please enter your option: ')

    if option == 1:
        global login
        login = input('Enter the name of the organization to create: ')

        try:
            create_organization()

            if create_organization() == 200:
                print(f'Organization {login} has been created.')
            else:
                print('An error has occurred. Please check the log for further details.')
        except:
            print('An error has been encountered. Please check the log for further details.')
        
    elif option == 2:
        admin = input('Please provide owner name: ')
        data = {'login': f'{login}', 'admin': f'{admin}'}

        set_organization_owner()

    elif option == 3:
        role = 'owner'

        get_organization_ownermember()

    elif option == 4:
        role = 'member'

        get_organization_ownermember()
    
    elif option == 5:
        print('You have selected to run all reports.')

        global report

        # Create owner extract
        try:
            report = 'owner'
            api_url = 'members?role=admin'
            iam_extract()
        except:
            print('Failed to generate owner extracts.')
        
        # Create member extract
        try:
            report = 'member'
            api_url = 'members?role=member'
            iam_extract()
        except:
            print('Failed to generate member extracts.')
        

        # Crate repository extract
        try:
            report = 'repository'
            api_url = 'repos'
            iam_extract()
        except:
            print('Failed to generate repository extracts.')
        


        else:
            print(f'''Please select a valid bumeric option. Valid options are;
            1
            2
            3
            4
            5

            {usage}
            
            ''')



def create_organization():
    try:
        logging.info(f'Creating organization {login}.')
        organization_url = requests.post(f'{environment_url}/api/v3/admin/organization', headers=header, json=data, verify='cacert')
        if (organization_url.status_code == 200):
            return 200
        else:
            logging.error(f'A HTTP error occured: {organization_url.status_code}')
    except:
        logging.error(f'Unable to create organization', exc_info=True)



owners = ['iamdsa']
owners = owners.append(iter(lambda: input('Enter owner to add or leave blank when done: ', owners)))



def set_organization_owner():
    try:
        logging.info(f'Adding owner to organization {login}.')
        organization_url = requests.post(f'{environment_url}/api/v3/admin/organizations', headers=header, json=data, verify='cacert')
        if (organization_url.status_code == 200):
            return 200
        else:
            logging.error(f'A HTTP error occured: {organization_url.status_code}')
    except:
        logging.error(f'Unable to set organization owner.', exc_info=True)



def get_organization_ownermember():
    try:
        logging.info(f'Retrieving {login} {role}.')
        organization_url = requests.get(f'{environment_url}/orgs/{login}/{api_url}', headers=header, verify='cacert')
        if (organization_url.status_code == 200):
            return 200
        else:
            logging.error(f'A HTTP error occured: {organization_url.status_code}')
    except:
        logging.error(f'Unable to retrieve organization owners.', exc_info=True)



def organization_extract_all():
# Make API call
    try:
        req = requests.get(f'{environment_url}/organizations', headers=header, verify='cacert')

        logging.info('REST call made')
        logging.info(f'Status code = {req.status_code}')

        if (req.status_code == 200):
            pass
        
        else:
            logging.error(f'An HTTP error occurred: {req.status_code}')
            sys.exit(1)

    except Exception as e:
        logging.error('An exception has occured', exc_info=True)
        logging.info(f'URL = {environment_url}/organizations')
        sys.exit(1)
    
    # Load returned JSON
    global logins
    logins = json.loads(req.text)



def iam_extract():
    
    # Loop over returned JSON list and extract organization names
    for login in logins:
        try:
            # Extract audit list                       
            login = login['login']
            logging.info(f'Starting {report} extract for {login}.')
            logging.info(f'{report} extract URL = {environment_url}/orgs/{login}/{api_url}')
            
            # Make report extract API call
            try:
                report_url = requests.get(f'{environment_url}/orgs/{login}/{api_url}', headers=header, verify='cacert')
                if (report_url.status_code == 200):
                    pass
                else:
                    logging.error(f'An HTTP error occurred: {report_url.status_code}')
                    sys.exit(1)
                try:
                    # Write to file
                    logging.info(f'Writing {report} extract for {login}.')
                    with open(f'Reports/{login}_{report}.json', 'w') as f:
                        f.write(report_url.text)
                    logging.info(f'Writing {report} extract for {login} completed!')
                except Exception as e:
                    logging.error(f'Unable to write {report} extract for {login}', exc_info=True)
                    sys.exit(1)
            except Exception as e:
                logging.error(f'Error extracting {report} list', exc_info=True)
        except Exception as e:
            logging.error('Unable to read list', exc_info=True)
            logging.error(f"{report} extract for {login} failed")



# Verify valid report type requested
if report.lower() == 'owner':
    role = 'owner'
    api_url = 'members?role=admin'
elif report.lower() == 'member':
    role = 'member'
    api_url = 'members?role=member'
elif report.lower() == 'repository':
    api_url = 'repos'



# Call the main function
ghe_support()



# Finish logging and gracefull exit
logging.info(f'Done!')
sys.exit(0)
