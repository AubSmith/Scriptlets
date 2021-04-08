systemctl cat name.service # Reads current unit config
systemctl show name.service # Shows all available config params
systemctl edit name.service # Edit service config

systemctl daemon-reload # Reload after edit
systemctl restart name.service # Restart service
