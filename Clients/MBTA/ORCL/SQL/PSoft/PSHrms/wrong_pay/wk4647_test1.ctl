OPTIONS (SKIP = 1, ERRORS = 1)
  
load data
infile 'C:\MISC\ORACLE\SQL\PSoft\PSHrms\wrong_pay\wk4647_test1.csv' 
BADFILE 'C:\MISC\ORACLE\SQL\PSoft\PSHrms\wrong_pay\wk4647_test1.bad'

TRUNCATE
into table test
fields terminated by "," optionally enclosed by '"'
TRAILING NULLCOLS             
(
earn	"ltrim(rtrim(:earn))",
empno "ltrim(rtrim(:empno))",
date1 "ltrim(rtrim(:date1))",
hrs "ltrim(rtrim(:hrs))",
rate "ltrim(rtrim(:rate))",
amount "ltrim(rtrim(:amount))"
)