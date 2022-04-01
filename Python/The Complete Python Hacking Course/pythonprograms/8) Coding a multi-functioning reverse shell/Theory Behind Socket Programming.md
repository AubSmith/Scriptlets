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

wine '/root/drive_c/python27/python.exe -m pip install pyinstaller
