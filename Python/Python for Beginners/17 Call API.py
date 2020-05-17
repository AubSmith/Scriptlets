import requests
import json

subscription_key = ''

vision_service_address =  "https://"

headers = {'Content-Type': 'Application/octet-stream',
            'Ocp-Apim-Suscription-Key' : subscription_key}

response = requests.post(address, headers=headers, params=parameters, \
                        data=image_data)

response.raise_for_status()

results = response.json
print(json.dumps(results))