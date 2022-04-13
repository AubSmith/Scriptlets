SELECT IdentityName,
StartTime,
Command,
IPAddress,
ExecutionTime
FROM tbl_Command WHERE CommandId IN
(SELECT Max(CommandId) FROM tbl_Command WHERE Application NOT LIKE 'Team Foundation JobAgent' Group By IdentityName ) ORDER BY Last_Access_Time DESC