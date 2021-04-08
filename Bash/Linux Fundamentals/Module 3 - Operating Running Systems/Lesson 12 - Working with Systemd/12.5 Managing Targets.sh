# Target is group of services
# Some targets are isolatable - i.e. use in state system should be in
# - emergency.target
# - rescue.target
# - multi-user.target
# - graphical.target

systemctl start name.target
systemctl isolate name.target
systemctl list-dependencies name.target  # See contents and dependencies of systemd target
systemctl get-default
systemctl set-default name.target


systemctl list-units | grep target

systemctl get-default

systemctl isolate multi-user.target

systemctl list-units

systemctl start graphical.target

systemctl set-default graphical.target

systemctl list-dependencies graphical.target