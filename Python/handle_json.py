import glob, json

dir_path = r"E:\Code\Python\Reports\*.json"
filename = []

for path in glob.glob(dir_path):
            filename.append(path)
            print(path)
            
            data = json.load(open(path, 'r'))
            
            for item in data:    
                print(item['storeNumber'])
                txt_out = path.replace("json","txt")
                with open(txt_out, 'a') as users:
                    users.write(str(item['storeNumber']))
                    users.write('\n')

            # print(data)

fullstring = "StackAbuse"
substring = "tack"

if substring in fullstring:
    print("Found!")
else:
    print("Not found!")

# data = json.loads(filename)     