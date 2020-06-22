OPTIONS (SKIP = 1, ERRORS = 1)
  
load data
infile 'C:\MISC\ORACLE\SQL\PSoft\PSHrms\wrong_pay\wk47bad.csv' 
BADFILE 'C:\MISC\ORACLE\SQL\PSoft\PSHrms\wrong_pay\wk47bad.bad'

TRUNCATE
into table testw47
fields terminated by "," optionally enclosed by '"'
TRAILING NULLCOLS             
(
earn	"ltrim(rtrim(:earn))",
empno "ltrim(rtrim(:empno))",
date1 "ltrim(rtrim(:date1))",
hrs "ltrim(rtrim(to_char(:hrs, '9999990.00')))",
rate "ltrim(rtrim(to_char(:rate, '9999990.00')))",
amount "ltrim(rtrim(to_char(:amount, '9999990.00')))"
)