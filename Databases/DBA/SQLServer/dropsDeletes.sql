--Below link outlines on queries to find drops and delete performed by a user in the DB
https://www.mssqltips.com/sqlservertip/3090/how-to-find-user-who-ran-drop-or-delete-statements-on-your-sql-server-objects/--Below outlines recovering from a truncate
https://raresql.com/2012/04/08/how-to-recover-truncated-data-from-sql-server-without-backup/
https://codingfry.blogspot.com/2018/09/how-to-recover-data-from-truncated.html
USE ReadingDBLog
GO
SELECT
    Operation,
    [Transaction ID],
    [Begin Time],
    [Transaction Name],
    [Transaction SID]
FROM
    fn_dblog(NULL, NULL)
WHERE
    [Transaction ID] = '0000:000004ce'
AND
    [Operation] = 'LOP_BEGIN_XACT'
USE ReadingDBLog
GO
SELECT 
Operation,
[Transaction Id],
[Transaction SID],
[Transaction Name],
 [Begin Time],
   [SPID],
   Description
FROM fn_dblog (NULL, NULL)
WHERE [Transaction Name] = 'DROPOBJ'
GO

SELECT SUSER_SNAME(0x0105000000000005150000009F11BA296C79F97398D0CF19E8030000) 