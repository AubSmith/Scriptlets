sudo cp -p /var/tmp/cacert.cer /etc/pki/ca-trust/source/anchors/
sudo update-ca-trust extract


trust list
trust list | grep thawte
trust list | grep digicert


opensll s_client -connect github.service.wayneent.com:443 -showcerts

