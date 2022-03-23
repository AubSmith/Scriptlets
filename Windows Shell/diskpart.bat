diskpart

list disk

select disk n

list partition

select partition n

# Extend partition in MBs
extend size=n

select partition n
delete partition override

# Create 10000MB
create partition primary size=10000

exit