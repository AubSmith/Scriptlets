crc setup
crc start

crc stop

crc console --credentials

The server is accessible via web console at:
  https://console-openshift-console.apps-crc.testing

Use the 'oc' command line interface:
  > @FOR /f "tokens=*" %i IN ('crc oc-env') DO @call %i
  > oc login -u developer https://api.crc.testing:6443