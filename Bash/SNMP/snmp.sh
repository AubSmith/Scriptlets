sudo apt-get update
sudo apt install snmp
sudo apt install snmp --fix-missing
ip address

# Hostname
snmpwalk -v3 -l authnoPriv -u username -a SHA -A Password 192.168.1.100 .1.3.6.1.2.1.1.5.0

# Disk Dimensions
snmpwalk -On -v3 -l authnoPriv -u username -a SHA -A Password 192.168.1.100 .1.3.6.1.4.1.2021.9


# MIX : 1 (iso). 3 (org). 6 (dod). 1 (internet). 4 (private). 1 (enterprises). 2021 (ucdavis). 9 (dskTable). 1 (dskEntry)
# OID : 1.3.6.1.4.1.2021.9.1
# TXT : iso. org. dod. internet. private. enterprises. ucdavis. dskTable. dskEntry

# 1.3.6.1.4.1.2021.9.1.1 (dskIndex)
# 1.3.6.1.4.1.2021.9.1.2 (dskPath)
# 1.3.6.1.4.1.2021.9.1.3 (dskDevice)
# 1.3.6.1.4.1.2021.9.1.4 (dskMinimum)
# 1.3.6.1.4.1.2021.9.1.5 (dskMinPercent)
# 1.3.6.1.4.1.2021.9.1.6 (dskTotal)
# 1.3.6.1.4.1.2021.9.1.7 (dskAvail)
# 1.3.6.1.4.1.2021.9.1.8 (dskUsed)
# 1.3.6.1.4.1.2021.9.1.9 (dskPercent)
# 1.3.6.1.4.1.2021.9.1.10 (dskPercentNode)
# 1.3.6.1.4.1.2021.9.1.100 (dskErrorFlag)
# 1.3.6.1.4.1.2021.9.1.101 (dskErrorMsg)

# Module	UCD-SNMP-MIB (netsnmp)
# Nom	dskEntry
# Status	current
# Description	An entry containing a disk and its statistics.
