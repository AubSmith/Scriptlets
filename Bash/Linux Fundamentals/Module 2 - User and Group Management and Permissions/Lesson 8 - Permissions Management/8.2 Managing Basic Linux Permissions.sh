# Change ownership
chgrp groupname object
chgrp user myfolder

chmod 770 myfolder/
chmod g-w myfolder/
chmod g+w myfolder/
chmod u-w,g+w myfile

chown username object
chown aubrey myfolder/
chown aubrey:administrators myfolder/

chown --reference=sourcefile targetfile
chmod --reference=sourcefile targetfile