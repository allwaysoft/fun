select p.spid -- This is process id we see at the operating system level.
, s.sid, s.serial#, s.username, s.status, s.osuser, s.machine, s.program, s.logon_time 
from v$process p, v$session s
where p.addr = s.paddr
order by status,  logon_time; 