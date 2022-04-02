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

# Convert Python to .exe
wine /home/esmith/.wine/drive_c/Python27/Scripts/easy_install-2.7.exe --onefile --noconsole rs.py

ls


# Use Apache for file transfer
mv python.exe /var/www//html
sudo service apache2 start
# Delete index.html if required
# Hit URL