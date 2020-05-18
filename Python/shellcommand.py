# 1

import os, subprocess

os.system("cmd")

# 2

subprocess.run(["powershell", "pwd"])
# On RHEL
# subprocess.run(["ls", "-l"])