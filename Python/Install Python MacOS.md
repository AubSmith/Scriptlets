curl https://bootstrap.pypa.io/get-pip.py -o ~/Downloads/get-pip.py

python ~/Downloads/get-pip.py --user

~/Library/Python/2.7/bin is in your $PATH. For bash users, edit the PATH= line in ~/.bashrc to append the local Python path; ie. PATH=$PATH:~/Library/Python/2.7/bin

source ~/.bashrc

pip install <package_name> --user