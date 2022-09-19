# Invoke the script as follows:
# python .\artifactoryAuditReport.py

# Import the required modules
import configparser, json, logging, requests, ssl, sys

# Enable logging and configure log filename
logging.basicConfig(filename="artifactoryAuditReport.log", level=logging.DEBUG)

# Import config from artifactory.ini
try:
    config = configparser.ConfigParser()
    config.readfp(open(r'Artifactory.ini'))
    logging.info('Config file has been read')
except:
    logging.error('Unable to read config file!')
    sys.exit(1)


# Load Artifactory environment settings
art = config.get('Environment', 'Test')


# Load credentials
username = config.get('User', 'UserName')
token = config.get('Token', 'TestToken')


# Set API method -  Change this API URL to required API method 
api = 'api/repositories'


# Make API call
try:
    req = requests.get(f'{art}/{api}', auth = (username, token), verify='cacert')
    logging.info('REST call made')
    logging.info(f'Status code = {req.status_code}')
    if (req.status_code == 200):
        pass
    else:
        logging.error(f'An HTTP error occurred: {req.status_code}')
        sys.exit(1)
except Exception as e:
    logging.error('An exception has occured', exc_info=True)
    logging.info(f'URL = {art}/{api}')
    sys.exit(1)


keys = json.loads(req.text)


def artifactory_audit_report():
    # Loop over returned JSON list and extract organization names
    for key in keys:
            try:
                # Extract audit list
                key = key['key']
                logging.info(f'Starting extract for {key}')
                logging.info(f'{key} extract URL = {art}/api/artifactpermissions?repoKey={key}')
                
                # Make report extract API call
                try:
                    report_url = requests.get(f'{art}/api/artifactpermissions?repoKey={key}', auth = (username, token), verify='cacert')
                    if (report_url.status_code == 200):
                        pass
                    else:
                        logging.error(f'An HTTP error occurred: {report_url.status_code}')
                        sys.exit(1)
                    try:
                        # Write report to disk
                        logging.info(f'Writing permission extract for {key}')
                        with open(f'Reports/{key}_permissions.json', 'w') as f:
                            f.write(report_url.text)
                        logging.info(f'Writing permission extract for {key} completed')
                    except Exception as e:
                        logging.error(f'Unable to write permission extract for {key}', exc_info=True)
                        sys.exit(1)
                except Exception as e:
                    logging.error(f'Error extracting permission target list', exc_info=True)
            except Exception as e:
                logging.error('Unable to read list', exc_info=True)
                logging.error(f'Permission Target extract for {key} failed')


# Invoke function
artifactory_audit_report()


# Finish
logging.info(f'Done!')
sys.exit(0)
