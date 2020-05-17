USE master;
GO
CREATE DATABASE kranthi_test1
ON 
( NAME = kranthi_dat1,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\kranthi_test_dat1.mdf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
LOG ON
( NAME = kranthi_log1,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\kranthi_test_log1.ldf',
    SIZE = 5MB,
    MAXSIZE = 25MB,
    FILEGROWTH = 5MB ) ;
GO

USE kranthi_test1;
GO
select physical_name from sys.database_files where type = 1

USE kranthi_test1;
GO
select a.name
     , b.name as 'Logical filename'
     , b.filename 
from sys.sysdatabases a 
inner join sys.sysaltfiles b
on a.dbid = b.dbid 
--where fileid = 2



