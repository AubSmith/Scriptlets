diskpart

list disk

select disk n

list partition

select partition n

rem Extend partition in MBs
extend size=n

select partition n
delete partition override

rem Change EFI System partition ID
SET ID=ebd0a0a2-b9e5-4433-87c0-68b6b72699c7

delete partition override

# Create 10000MB
create partition primary size=10000

exit