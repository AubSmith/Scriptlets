systemctl unit-files
systemctl list-units --type service
systemctl status sshd.service
systemctl restart sshd.service
systemctl reload sshd.service
systemctl start sshd.service
systemctl enable sshd.service