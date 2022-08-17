unshadow ./passwd ./shadow >> out
sudo gzip -d /usr/share/wordlists/rockyou.txt.gz
hashcat -m 1800 out /usr/share/wordlists/rockyou.txt -O