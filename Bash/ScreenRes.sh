# Run ScreenRes.ps1

sudo vi /etc/default/grub
# Configure following line - save and reboot
GRUB_CMDLINE_LINUX_DEFAULT="quiet video=hyperv_fb:1920×1080"