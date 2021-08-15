from string import maketrans

rot13trans = maketrans('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', 
   'NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm')

# Function to translate plain text
def rot13(text):
   return text.translate(rot13trans)
def main():
   txt = "ROT13 Algorithm"
   print rot13(txt)
	
if __name__ == "__main__":
   main()