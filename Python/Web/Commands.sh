    1  sudo subscription-manager status
    2  sudo vi /etc/sudoers
    3  exit
    4  sudo yum remove firefox
    5  sudo yum install vscode
    6  ping google.com
    7  history
    8  sudo subscription-manager status
    9  sudo subscription-manager register
   10  sudo subscription-manager attach
   11  cd Downloads/
   12  curl https://az764295.vo.msecnd.net/stable/dfd34e8260c270da74b5c2d86d61aee4b6d56977/code-1.66.2-1649664637.el7.x86_64.rpm -o vscode.rpm
   13  curl https://packages.microsoft.com/yumrepos/edge/microsoft-edge-stable-101.0.1210.32-1.x86_64.rpm -o msedge.rpm
   14  sudo yum module install python39/build
   15  cd Code/pythonweb/
   16  python3.9 -u pythonweb.py
   17  podman build -t pythonweb .
   18  podman images
   19  podman run --detach --publish 8000:8000 --name=pythonweb localhost/pythonweb
   20  podman ps
   21  podman stop pythonweb
   22  podman rm pythonweb
   23  history