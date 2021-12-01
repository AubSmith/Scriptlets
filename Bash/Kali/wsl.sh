# Update
sudo apt update
sudo apt full-upgrade -y

# GUI
sudo apt install -y kali-win-kex

# Window with sound
kex --win -s

# Seamless with sound
kex --sl -s

# Windows Terminal
#
# {
#        "guid": "{55ca431a-3a87-5fb3-83cd-11ececc031d2}",
#        "hidden": false,
#        "icon": "file:///c:/users/<windows user>/pictures/icons/kali-menu.png",
#        "name": "Win-KeX",
#        "commandline": "wsl -d kali-linux kex --sl --wtstart -s",
#        "startingDirectory" : "//wsl$/kali-linux/home/<kali user>"
# },