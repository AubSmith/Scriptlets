dd if=/dev/zero of=bigfile1 bs=1M count=1024

dd if=/dev/zero of=bigfile2 bs=1M count=1024

dd if=/dev/zero of=bigfile3 bs=1M count=1024

ls -l bigfile*

time gzip bigfile1
time bzip bigfile2
time zip bigfile3.zip bigfile3

ls -l bigfile*

# gunzip bigfile1

mv bigfile1 bigdfile1
file bigdfile1