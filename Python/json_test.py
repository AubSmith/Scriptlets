# Todo:
# Filter JSON to CSV by value
# Add Custom field to CSV
# Replace JSON to CSV value

import csv, json, logging

# print([db_item["supplier"] for db_item in db])

test = """{
    "firstName": "Jane",
    "lastName": "Doe",
    "hobbies": "running",
    "age": 35
}
"""

json.loads(test)
data = json.loads(test)
                    
if not data:

    print("Data is empty}.")

else:
    print(data)
    print(type(data))

    headers = data.keys()

    # Write to file
    with open('test.csv', 'a+', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=headers)
        #writer = csv.DictWriter(f, fieldnames=['firstname','lastname'],extrasaction='ignore')
        writer.writeheader()
        writer.writerow(data)
