use Acadian
go
drop table Acadian.dbo.t

create table Acadian.dbo.t (a numeric, b numeric)

insert into t values (1,100)
insert into t values (2,101)drop table Acadian.dbo.t1

create table Acadian.dbo.t1 (a numeric, b numeric)

insert into t1 values (1,200)update t
set t.b = t1.b
from Acadian.dbo.t
LEFT JOIN Acadian.dbo.t1 on t.a = t1.a
select * from Acadian.dbo.t;