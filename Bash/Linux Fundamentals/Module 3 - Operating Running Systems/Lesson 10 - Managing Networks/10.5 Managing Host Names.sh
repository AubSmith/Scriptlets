hostname
hostname -I
cat /etc/hostname

hostnamectl --help
hostnamectl status
hostnamectl set-hostname newhostname

uname -a

env | grep hostname # Where hostname is the physical PC name
