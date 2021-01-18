jsongpg = { 'alias': 'Distribution public key',
            'public_key': 'Pulic key'
            }

filename = "D:\jsongpg.json"

f = open(filename, 'w')
print(jsongpg, file=f)