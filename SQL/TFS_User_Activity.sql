SELECT DISTINCT IdentityName, StartTime
FROM tbl_Command
WHERE IdentityName IS NOT NULL
ORDER BY StartTime Desc;