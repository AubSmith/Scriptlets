registry.example.com/username/imagename
quay.io/rdacosta/mywebserver:latest

Need
SELinux
Namespaces
Cgroups

Kernel namespace0
Container isolated namespace



some applications will treat "localhost" specially. the mysql client will treat localhost as a request to connect to the local unix domain socket instead of using tcp to connect to the server on 127.0.0.1. This may be faster, and may be in a different authentication zone.
Differs between Windows and Linux. If you use a unix domain socket it'll be slightly faster than using TCP/IP (because of the less overhead you have).
Windows is using TCP/IP as a default, whereas Linux tries to use a Unix Domain Socket if you choose localhost and TCP/IP if you take 127.0.0.1.

+ the nasty thing in linux is when you specify 'localhost' as host, and a specific port, it just ignores the whole port bit and uses the default socket, not something one wants when running multiple servers on a single machine (hence the different port

easily avoidable by using 127.0.0.1:port 