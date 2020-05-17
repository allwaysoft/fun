
EXEC msdb.dbo.sp_send_dbmail
@recipients='kpabba@mbta.com',
@subject='Test message',
@body='This is the body of the test message. Congrats Database Mail Received By you Successfully.' 

SELECT *
FROM msdb.dbo.sysmail_mailitems
GO
SELECT *
FROM msdb.dbo.sysmail_log
GO
SELECT *
FROM msdb.dbo.sysmail_even_log
OG
select * 
from msdb.dbo.sysmail_sentitems
GO  


select 'abc' + ' ' + 'def'