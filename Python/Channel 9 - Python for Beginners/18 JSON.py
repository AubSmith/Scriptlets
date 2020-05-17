# Process JSON

import requests
import json



api_address = 'https://art.srvc.domain.com/api'

response = requests.post(api_address)

respone.raise_for_status()

results = respone.json()
print(json.dumps(results))

print()



# Create JSON

import json

# Create dictionary object
person_dict = {'first' : 'Christopher', 'last' : 'Harrison'}
# Add additional key pais as required
person_dict['City']='Seattle'

# Convert dictionary to JSON object
person_json = json.dumps(person_dict)
print(person_json)



# JSON subkey

person_dict = {'first' : 'Christopher', 'last' : 'Harrison'}

staff_dict = {}
staff_dict['Program Manager']=person_dict


staff_json = json.dumps(staff_dict)

print(staff_json)



# JSON list values

person_dict = {'first' : 'Christopher', 'last' : 'Harrison'}

languages_list = ['CSharp', 'Python', 'Javascript' ]
person_dict['languages'] = languages_list

person_json = json.dumps(person_dict)

print(person_json)
