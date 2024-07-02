[environment]::OSVersion.Version

(Get-CimInstance Win32_OperatingSystem).version


(Get-WmiObject Win32_OperatingSystem).OperatingSystemSKU
<#
Value  Meaning
-----  -------
    0  Undefined
    1  Ultimate Edition
    2  Home Basic Edition
    3  Home Premium Edition
    4  Enterprise Edition
    5  Home Basic N Edition
    6  Business Edition
    7  Standard Server Edition
    8  Datacenter Server Edition
    9  Small Business Server Edition
   10  Enterprise Server Edition
   11  Starter Edition
   12  Datacenter Server Core Edition
   13  Standard Server Core Edition
   14  Enterprise Server Core Edition
   15  Enterprise Server Edition for Itanium-Based Systems
   16  Business N Edition
   17  Web Server Edition
   18  Cluster Server Edition
   19  Home Server Edition
   20  Storage Express Server Edition
   21  Storage Standard Server Edition
   22  Storage Workgroup Server Edition
   23  Storage Enterprise Server Edition
   24  Server For Small Business Edition
   25  Small Business Server Premium Edition
   29  Web Server, Server Core
   39  Datacenter Edition without Hyper-V, Server Core
   40  Standard Edition without Hyper-V, Server Core
   41  Enterprise Edition without Hyper-V, Server Core
   42  Hyper-V Server
#>