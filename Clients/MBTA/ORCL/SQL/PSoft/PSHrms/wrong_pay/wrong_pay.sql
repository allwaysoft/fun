create table test (earn varchar2(10), empno varchar2(10), date1 varchar2(10), hrs varchar2(10), rate varchar2(10), amount varchar2(10))



create table prod (earnp varchar2(10), empnop varchar2(10), date1p varchar2(10), hrsp varchar2(10), ratep varchar2(10), amountp varchar2(10))

drop table prod



select count(1) from test


select count(1) from prod

select t.earn, t.empno, t.date1, t.hrs, t.rate, t.amount, p.amountp  
from test t, prod p 
where upper(T.EARN)=upper(p.earnp (+))
and upper(t.empno)=upper(p.empnop (+))
and upper(t.date1)=upper(P.DATE1P (+))
and upper(T.HRS)=upper(p.hrsp (+))
and upper(t.rate)=upper(p.ratep (+))
and upper(amount) <> upper(amountp(+))
and p.earnp is not null 
order by earn, empno, date1, hrs, rate


select ratep, ltrim(rtrim(to_char(ratep, '9999990.00'))) from prod
where empnop='1254'


create table test1 as
select earn, empno, date1,ltrim(rtrim(to_char(hrs, '9999990.00'))) hrs,ltrim(rtrim(to_char(rate, '9999990.00'))) rate,ltrim(rtrim(to_char(amount, '9999990.00'))) amount 
from test


create table prod1 as
select earnp, empnop, date1p,ltrim(rtrim(to_char(hrsp, '9999990.00'))) hrsp,ltrim(rtrim(to_char(ratep, '9999990.00'))) ratep,ltrim(rtrim(to_char(amountp, '9999990.00'))) amountp 
from prod



commit

select t.earn, t.empno, t.date1, t.hrs, t.rate, t.amount
       ,p.earnp, p.empnop, p.date1p, p.hrsp, p.ratep, p.amountp  
from test1 t, prod1 p 
where upper(T.EARN)=upper(p.earnp (+))
and upper(t.empno)=upper(p.empnop (+))
and upper(t.date1)=upper(P.DATE1P (+))
and upper(T.HRS)=upper(p.hrsp (+))
and upper(t.rate)=upper(p.ratep (+))
and upper(t.amount) <> upper(p.amountp(+))
--and p.earnp is null 
and empno='1254'
order by earn, empno, date1, hrs, rate


select * from test1 where empno='1254'

select * from prod1 where empnop='1254'

REG    1254    11/12/2012    1.40    30.80    51.33
REG    1254    11/12/2012    6.20    30.48    193.04


REG    1254    11/12/2012    1.40    30.80    51.33
REG    1254    11/12/2012    6.20    30.48    193.04


select t.earn, t.empno, t.date1, t.hrs, t.rate, t.amount
       ,p.earnp, p.empnop, p.date1p, p.hrsp, p.ratep, p.amountp, t.amount-p.amountp difference  
from test1 t, testw46 p 
where T.EARN=p.earnp 
and t.empno=p.empnop
and t.date1=P.DATE1P
and T.HRS=p.hrsp
--and t.rate=p.ratep
and t.amount <> p.amountp
--and p.earnp is null
--and t.empno='1254' 
order by earn, empno, date1, hrs, rate



create table testw47 (earn varchar2(10), empno varchar2(10), date1 varchar2(10), hrs varchar2(10), rate varchar2(10), amount varchar2(10)) 


select count(1) from test1 where to_Date(date1,'mm/dd/yyyy') between to_Date('11/10/2012','mm/dd/yyyy') and to_Date('11/16/2012','mm/dd/yyyy')

select * from test1 where to_Date(date1,'mm/dd/yyyy') between to_Date('11/17/2012','mm/dd/yyyy') and to_Date('11/23/2012','mm/dd/yyyy')
and empno = '67478'

REG    67478    11/22/2012    8.00    30.48    243.84
REG    67478    11/23/2012    8.00    30.48    243.84

select count(1) from testw46


select t.earn earn_good, t.empno empno_good, t.date1 date_good, t.hrs hrs_good, t.rate rate_good, t.amount amount_good
     , p.earn earn_bad, p.empno empno_bad, p.date1 date_bad, p.hrs hrs_bad, p.rate rate_bad, p.amount amount_bad, t.amount-p.amount difference  
from test1 t, testw46 p 
where T.EARN=p.earn 
and t.empno=p.empno
and t.date1=P.DATE1
and T.HRS=p.hrs
--and t.rate=p.ratep
and t.amount <> p.amount
and to_Date(t.date1,'mm/dd/yyyy') between to_Date('11/10/2012','mm/dd/yyyy') and to_Date('11/16/2012','mm/dd/yyyy')
--and p.earnp is null
--and t.empno='1254' 
order by t.earn, t.empno, t.date1, t.hrs, t.rate


select t.earn earn_good, t.empno empno_good, t.date1 date_good, t.hrs hrs_good, t.rate rate_good, t.amount amount_good
     , p.earn earn_bad, p.empno empno_bad, p.date1 date_bad, p.hrs hrs_bad, p.rate rate_bad, p.amount amount_bad, t.amount-p.amount difference  
from test1 t, testw46 p 
where T.EARN=p.earn 
and t.empno=p.empno
and t.date1=P.DATE1
and T.HRS=p.hrs
--and t.rate=p.ratep
and t.amount <> p.amount
and to_Date(t.date1,'mm/dd/yyyy') between to_Date('11/10/2012','mm/dd/yyyy') and to_Date('11/16/2012','mm/dd/yyyy')
--and p.earnp is null
--and t.empno='1254'
and t.empno not in ('2280','65151','65262','65726','66645','67246','67663') 
order by t.earn, t.empno, t.date1, t.hrs, t.rate

select * from testw46 where empno = '67663'


select * from test1 where empno = '67663'




select t.earn earn_good, t.empno empno_good, sum(t.amount-p.amount) difference  
from test1 t, testw46 p 
where T.EARN=p.earn 
and t.empno=p.empno
and t.date1=P.DATE1
and T.HRS=p.hrs
--and t.rate=p.ratep
and t.amount <> p.amount
and to_Date(t.date1,'mm/dd/yyyy') between to_Date('11/10/2012','mm/dd/yyyy') and to_Date('11/16/2012','mm/dd/yyyy')
--and p.earnp is null
--and t.empno='1254'
and t.empno not in ('2280','65151','65262','65726','66645','67246')
group by t.earn, t.empno 
order by t.earn, t.empno



REG    67478    11/19/2012    4.31    30.48    137.67

REG    67478    11/20/2012    4.38    30.48    141.22

REG    67478    11/21/2012    6.20    30.48    193.04

REG    67478    11/22/2012    8.00    30.48    243.84
REG    67478    11/23/2012    8.00    30.48    243.84


REG    67478    11/19/2012    3.29    27.72    96.56
REG    67478    11/20/2012    3.22    27.72    93.32
REG    67478    11/21/2012    1.40    27.72    46.20


select t.earn, t.empno, t.date1, t.hrs, t.rate, t.amount
       --,p.earnp, p.empnop, p.date1p, p.hrsp, p.ratep, p.amountp  
from test1 t, prod1 p 
where T.EARN=p.earnp(+) 
and t.empno=p.empnop(+)
and t.date1=P.DATE1P(+)
and T.HRS=p.hrsp(+)
--and t.rate=p.ratep(+)
--and t.amount <> p.amountp(+)
and p.earnp is null
--and t.empno='1254' 
order by earn, empno, date1, hrs, rate

select count(1) from testw47


select t.earn earn_good, t.empno empno_good, t.date1 date_good, t.hrs hrs_good, t.rate rate_good, t.amount amount_good
     , p.earn earn_bad, p.empno empno_bad, p.date1 date_bad, p.hrs hrs_bad, p.rate rate_bad, p.amount amount_bad, t.amount-p.amount difference  
from test1 t, testw47 p 
where T.EARN=p.earn 
and t.empno=p.empno
and t.date1=P.DATE1
and T.HRS=p.hrs
--and t.rate=p.ratep
and t.amount <> p.amount
and to_Date(t.date1,'mm/dd/yyyy') between to_Date('11/17/2012','mm/dd/yyyy') and to_Date('11/23/2012','mm/dd/yyyy')
--and p.earnp is null
--and t.empno='1254' 
order by t.earn, t.empno, t.date1, t.hrs, t.rate



select t.earn earn_good, t.empno empno_good, sum(t.amount-p.amount) difference  
from test1 t, testw47 p 
where T.EARN=p.earn 
and t.empno=p.empno
and t.date1=P.DATE1
and T.HRS=p.hrs
--and t.rate=p.ratep
and t.amount <> p.amount
and to_Date(t.date1,'mm/dd/yyyy') between to_Date('11/17/2012','mm/dd/yyyy') and to_Date('11/23/2012','mm/dd/yyyy')
--and p.earnp is null
--and t.empno='1254'
and t.empno not in ('65151','65262','65398')
group by t.earn, t.empno 
order by t.earn, t.empno

select * from testw47 where empno = '67478'