dd if =/dev/zero of=/dev/null
bg
dd if =/dev/zero of=/dev/null &
dd if =/dev/zero of=/dev/null &
dd if =/dev/zero of=/dev/null &
jobs
fg
fg 2
# Ctrl C kill job
