# Import required Python modules
import configparser, json, logging, requests, ssl, sys


# Enable logging and configure log filename
logging.basicConfig(filename="ghe_support.log", level=logging.DEBUG)


usage = """
USAGE: ./ghe_support.py environment

Environment is the environment in which the support activity is to take place. Valid input is either;
prod
test

Select one of the following options to be run - enter numeric value;
1 - Create organization
2 - Add owner to organization
3 - List owners of an organization
4 - List members of an organization
5 - Run IAM reports for all organizations
6 - Quit

"""


# Import config from ghe.ini
try:
    config = configparser.ConfigParser()
    config.readfp(open(r"ghe.ini"))
    logging.info("Config file has been read")
except:
    logging.error("Unable to read config file!")
    sys.exit(1)


# Assign variables based on input parameters
# Environment to read config values for - either test or prod
if len(sys.argv) != 2:
    print(usage)
    logging.error(
        f"Incorrect usage! Please specify and environment when invoking this script. \n {usage}"
    )
    sys.exit(1)
else:
    environment = sys.argv[1]
    print(f"{environment}")


# Verify valid environment specified
if environment.lower() == "test":
    environment_url = config.get("Environment", "Test")
    token = config.get("Token", "TestToken")
    iam_account = config.get("IAM", "TestAccount")
    admin = config.get("Token", "TestAccount")
    logging.info(f"Environment set is {environment_url}")

elif environment.lower() == "prod":
    environment_url = config.get("Environment", "Production")
    token = config.get("Token", "ProdToken")
    iam_account = config.get("IAM", "ProductionAccount")
    admin = config.get("Token", "ProdAccount")
    logging.info(f"Environment set is {environment_url}")

elif environment.lower() == "-h":
    print(usage)

else:
    logging.error(
        "Invalid environment specified. Valid environments are test or prod."
    )
    sys.exit(1)


# Set REST request header
header = {
    "Accept-Language": "application/vnd.github+json",
    "Authorization": f"token {token}",
}


# Logic to handle support functions
def ghe_support():

    # Loop through menu options
    while True:

        # Print utility options
        print(
            f"""
        
        Select one of the following options to be run in the {environment.lower()} environment:
        1 - Create organization
        2 - Add owner to organization
        3 - List owners of an orgaization
        4 - List members of an organization
        5 - Run IAM reports for all organizations
        6 - Quit
    
        """
        )

        try:
            option = input("Please enter your option: ")

            if option == "1":
                global login
                global admin
                global data

                login = input("Enter the name of the organization to create: ")    
                admin = admin

                data = {"login": f"{login}", "admin": f"{admin}"}

                try:
                    create_organization()

                    if create_organization() == 200:
                        print(f"Organization {login} has been created.")
                    else:
                        print(
                            "An error has occurred. Please check the log for further details."
                        )
                except:
                    print(
                        "An error has been encountered. Please check the log for further details."
                    )

                try:
                    admin = iam_account
                    data = {"role": "admin"}

                    try:
                        set_organization_owner()

                        if set_organization_owner() in (200, 201):
                            print(
                                f"User {admin} has been successfully added to organization {login}."
                            )
                        else:
                            logging.error(
                                f"Unexpected error adding IAM account as owner",
                                exc_info=True,
                            )
                            print(
                                "An expected error occurred updating the organization owner. Please see the log for details."
                            )
                    except:
                        logging.error(
                            f"Unable to update IAM account as owner",
                            exc_info=True,
                        )
                        print(
                            "An error has been encountered. Please check the log for further details."
                        )
                except:
                    logging.error(
                        f"Unable to update IAM account as owner", exc_info=True
                    )
                    print(
                        "An error has been encountered. Please check the log for further details."
                    )

                try:
                    owner_add = input(
                        """Do you wish to add another owner?
                                     Yes = y
                                     No = n
                                     """
                    )

                    if owner_add.lower() == "y":
                        admin = input("Enter organization owner: ")

                        data = {"role": "admin"}

                        try:
                            set_organization_owner()

                            if set_organization_owner() in (200, 201):
                                print(
                                    f"User {admin} has been successfully added to organization {login}."
                                )
                            else:
                                print(
                                    "An error has occurred. Please check the log for further details."
                                )
                        except:
                            print(
                                "An error has been encountered. Please check the log for further details."
                            )

                    elif owner_add.lower() == "n":
                        pass

                    else:
                        print(
                            "Invalid option. Options are y/n. Please update owner via options menu."
                        )

                except:
                    logging.error(
                        f"Unexpected error adding owner", exc_info=True
                    )
                    print(
                        "An expected error occurred updating the organization owner. Please see the log for details."
                    )

            elif option == "2":
                login = input("Please provide organization name: ")
                admin = input("Please provide owner name: ")

                data = {"role": "admin"}

                try:
                    set_organization_owner()

                    if set_organization_owner() in (200, 201):
                        print(
                            f"User {admin} has been successfully added to organization {login}."
                        )
                    else:
                        print(
                            "An error has occurred. Please check the log for further details."
                        )
                except:
                    print(
                        "An error has been encountered. Please check the log for further details."
                    )

            elif option == "3":
                global role
                global api_url

                login = input("Please provide organization name: ")
                role = "owner"
                api_url = "members?role=admin"

                get_organization_ownermember()

            elif option == "4":
                login = input("Please provide organization name: ")
                role = "member"
                api_url = "members?role=member"

                get_organization_ownermember()

            elif option == "5":
                global report

                print("You have selected to run all reports.")

                try:
                    organization_extract_all()
                except:
                    print(
                        "Unable to retrieve list of organizations. Please see the log for details."
                    )

                    # Create owner extract
                    try:
                        report = "owner"
                        api_url = "members?role=admin"
    
                        iam_extract()
    
                    except:
                        print("Failed to generate owner extracts.")
    
                    # Create member extract
                    try:
                        report = "member"
                        api_url = "members?role=member"
    
                        iam_extract()
    
                    except:
                        print("Failed to generate member extracts.")
    
                    # Create repository extract
                    try:
                        report = "repository"
                        api_url = "repos"
    
                        iam_extract()
    
                    except:
                        print("Failed to generate repository extracts.")
            elif option == "6":
                print("Goodbye")

                return

            else:
                pass

        except:
            print(
                f"""Please select a valid numeric option. 
    
                {usage}
                
                """
            )


def create_organization():
    try:
        logging.info(f"Attempting to create organization {login}.")
        organization_url = requests.post(
            f"{environment_url}/api/v3/admin/organizations",
            headers=header,
            json=data,
            verify="cacert",
        )
        if organization_url.status_code in (200, 201, 422):
            return 200
        else:
            logging.error(
                f"A HTTP error occured: {organization_url.status_code}"
            )
    except:
        logging.error(f"Unable to create organization", exc_info=True)


def set_organization_owner():
    try:
        logging.info(f"Attempting to add owner to organization {login}.")
        organization_url = requests.put(
            f"{environment_url}/api/v3/orgs/{login}/memberships/{admin}",
            headers=header,
            json=data,
            verify="cacert",
        )
        if organization_url.status_code in (200, 201):
            return 200
        else:
            logging.error(
                f"A HTTP error occured: {organization_url.status_code}"
            )
    except:
        logging.error(f"Unable to set organization owner.", exc_info=True)


def get_organization_ownermember():
    try:
        logging.info(f"Retrieving {login} {role}.")
        organization_url = requests.get(
            f"{environment_url}/api/v3/orgs/{login}/{api_url}",
            headers=header,
            verify="cacert",
        )
        if organization_url.status_code in (200, 201):
            pass
        else:
            logging.error(
                f"A HTTP error occured: {organization_url.status_code}"
            )
        try:
            logging.info(f"Writing {role} report for {login}")

            # Write file to disk
            with open(f"Reports/{login}_{role}.json", "w") as f:
                f.write(organization_url.text)

            logging.info(f"Writing {role} report for {login} completed!")
            print(
                "\n Writing {role} report for {login} completed! \n Report can be found in .\\Reports\\{login}_{role}.json"
            )

        except:
            logging.error(f"Unable to write {role} log for {login}")
    except:
        logging.error(
            f"Unable to retrieve organization owners.", exc_info=True
        )


def organization_extract_all():
    # Make API call
    try:
        req = requests.get(
            f"{environment_url}/api/v3/organizations",
            headers=header,
            verify="cacert",
        )

        logging.info("REST call made")
        logging.info(f"Status code = {req.status_code}")

        if req.status_code == 200:
            pass

        else:
            logging.error(f"An HTTP error occurred: {req.status_code}")
            sys.exit(1)

    except Exception as e:
        logging.error("An exception has occured", exc_info=True)
        logging.info(f"URL = {environment_url}/api/v3/organizations")
        sys.exit(1)

    # Load returned JSON
    global logins
    logins = json.loads(req.text)


def iam_extract():

    # Loop over returned JSON list and extract organization names
    for login in logins:
        try:
            # Extract audit list
            login = login["login"]
            logging.info(f"Starting {report} extract for {login}.")
            logging.info(
                f"{report} extract URL = {environment_url}/orgs/{login}/{api_url}"
            )

            # Make report extract API call
            try:
                report_url = requests.get(
                    f"{environment_url}/orgs/{login}/{api_url}",
                    headers=header,
                    verify="cacert",
                )
                if report_url.status_code == 200:
                    pass
                else:
                    logging.error(
                        f"An HTTP error occurred: {report_url.status_code}"
                    )
                    sys.exit(1)
                try:
                    # Write to file
                    logging.info(f"Writing {report} extract for {login}.")
                    with open(f"Reports/{login}_{report}.json", "w") as f:
                        f.write(report_url.text)
                    logging.info(
                        f"Writing {report} extract for {login} completed!"
                    )
                except Exception as e:
                    logging.error(
                        f"Unable to write {report} extract for {login}",
                        exc_info=True,
                    )
                    sys.exit(1)
            except Exception as e:
                logging.error(f"Error extracting {report} list", exc_info=True)
        except Exception as e:
            logging.error("Unable to read list", exc_info=True)
            logging.error(f"{report} extract for {login} failed")


# Call the main function
ghe_support()


# Finish logging and gracefull exit
logging.info(f"Done!")
sys.exit(0)
