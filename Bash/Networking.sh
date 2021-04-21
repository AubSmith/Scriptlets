nmcli connection show
nmcli connection show Wired\ connection\ 1
nmcli device show
nmcli con add con-name XXXX type xxx ifname xxxx
nmcli connection show --active
nmcli con mod xxxx ipv4.addresses xxx.xxx.xxx.xxx/24
nmcli con mod xxxx ipv4.gateway xxx.xxx.xxx.xxx
nmcli con mod xxxx ipv4.dns xxx.xxx.xxx.xxx
nmcli con show
nmcli con delete xxxx
nmcli con up xxxx
nmcli con mod Wired\ connection\ 1 ipv4.addresses +xxx.xxx.xxx.xxx/24
nmcli con mod Wired\ connection\ 1 +ipv4.dns xxx.xxx.xxx.xxx
nmcli connection show Wired\ connection\ 1
ip a s xxxx
cat /etc/resolv.conf
nmcli con up xxxx