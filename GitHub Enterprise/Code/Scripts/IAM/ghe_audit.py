# Import required Python modules
import configparser, json, logging, requests, ssl, sys


def iam_extract():
    # Loop over returned JSON list and extract organization names
    for login in logins:
            try:
                # Extract audit list
                logging.info(f"Starting {report} extract for {login['login']}")
                login = login['login']
                logging.info(f'{report} extract URL = {ghe}/orgs/{login}/{api_url}')
                
                # Make report extract API call
                try:
                    report_url = requests.get(f'{ghe}/orgs/{login}/{api_url}', headers=header, verify='cacert')
                    if (report_url.status_code == 200):
                        pass
                    else:
                        logging.error(f'An HTTP error occurred: {report_url.status_code}')
                        sys.exit(1)
                    try:
                        # Write report to disk
                        logging.info(f'Writing {report} extract for {login}')
                        with open(f'Reports/{login}_{report}.json', 'w') as f:
                            f.write(report_url.text)
                        logging.info(f'Writing {report} extract for {login} completed')
                    except Exception as e:
                        logging.error(f'Unable to write {report} extract for {login}', exc_info=True)
                        sys.exit(1)
                except Exception as e:
                    logging.error(f'Error extracting {report} list', exc_info=True)
            except Exception as e:
                logging.error('Unable to read list', exc_info=True)
                logging.error(f"{report} extract for {login['login']} failed")


# Enable logging and configure log filename
logging.basicConfig(filename="ghe_iam.log", level=logging.DEBUG)


# Import config from ghe.ini
try:
    config = configparser.ConfigParser()
    config.readfp(open(r'ghe.ini'))
    logging.info('Config file has been read')
except:
    logging.error('Unable to read config file!')
    sys.exit(1)


# Read config variables
ghe = config.get('Environment', 'Production')
token = config.get('Token', 'ProdToken')


# Set REST request header
header = {'Accept-Language': 'application/vnd.github+json',
          'Authorization': f'token {token}'
         }


# Make API call
try:
    req = requests.get(f'{ghe}/organizations', headers=header, verify='cacert')
    logging.info('REST call made')
    logging.info(f'Status code = {req.status_code}')
    if (req.status_code == 200):
        pass
    else:
        logging.error(f'An HTTP error occurred: {req.status_code}')
        sys.exit(1)
except Exception as e:
    logging.error('An exception has occured', exc_info=True)
    logging.info(f'URL = {ghe}/organizations')
    sys.exit(1)


# Load returned JSON
logins = json.loads(req.text)


# Assign variables based on input parameters
report = sys.argv[1]


# Verify valid report type requested
if report.lower() == 'owner':
    api_url = 'members?role=admin'
elif report.lower() == 'member':
    api_url = 'members?role=member'
elif report.lower() == 'repository':
    api_url = 'repos'
elif report.lower() == 'all':
    # Create owner extract
    try:
        report = 'owner'
        api_url = 'members?role=admin'
        iam_extract()
    except:
        logging.error('Failed to generate owner extracts.')
    
    # Create member extract
    try:
        report = 'member'
        api_url = 'members?role=member'
        iam_extract()
    except:
        logging.error('Failed to generate member extracts.')
    
    # Create repository extract
    try:
        report = 'repository'
        api_url = 'repos'
        iam_extract()
    except:
        logging.error('Failed to generate repository extracts.')

else:
    logging.error('Invalid report. Valid reports are owner, member, repository, all')
    sys.exit(1)


# Invoke function
iam_extract()


# Finish
logging.info(f'Done!')
sys.exit(0)
