import configparser
# Import required Python modules
import json, logging, requests, ssl, sys

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

# Loop over returned JSON list and extract organization names
for login in logins:
    try:
        logging.info(f"Starting member extract for {login['login']}")
        login = login['login']
        logging.info(f'Member extract URL = {ghe}/orgs/{login}/members')
        try:
            reply = requests.get(f'{ghe}/orgs/{login}/members', headers=header, verify='cacert')
            if (reply.status_code == 200):
                pass
            else:
                logging.error(f'An HTTP error occurred: {reply.status_code}')
                sys.exit(1)
            try:
                logging.info(f'Writing report for {login}')
                with open(f'Reports/{login}.json', 'w') as f:
                    f.write(reply.text)
                logging.info(f'Writing report for {login} completed')
            except Exception as e:
                logging.error(f'Unable to write log for {login}', exc_info=True)
                sys.exit(1)
        except Exception as e:
            logging.error('Error extracting member list', exc_info=True)
    except Exception as e:
        logging.error('Unable to read list', exc_info=True)
        logging.error(f"Member extract for {login['login']} failed")

# Finish
logging.info(f'Done!')
sys.exit(0)
