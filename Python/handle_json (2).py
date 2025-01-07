import getpass, glob, json, smtplib

dir_path = r"/volumes/32GB/Code/Reports/*.json"
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

port = 125
username = getpass.getuser()
password = getpass.getpass("Type your password and press enter: ")


with smtplib("smtp.gmail.com", port) as server:
    server.login("my@gmail.com", password)

