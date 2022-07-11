# Spawn shells
# python -c 'import pty; pty.spawn("/bin/sh")'
# python -c 'import pty; pty.spawn("/bin/bash")'
import pty

pty.spawn("/bin/bash")
