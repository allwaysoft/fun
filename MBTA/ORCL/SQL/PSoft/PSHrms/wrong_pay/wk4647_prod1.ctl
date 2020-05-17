OPTIONS (SKIP = 1, ERRORS = 1)
  
load data
infile 'C:\MISC\ORACLE\SQL\PSoft\PSHrms\wrong_pay\wk4647_prod1.csv' 
BADFILE 'C:\MISC\ORACLE\SQL\PSoft\PSHrms\wrong_pay\wk4647_prod1.bad'

TRUNCATE
into table prod
fields terminated by "," optionally enclosed by '"'
TRAILING NULLCOLS             
(
earnp	"ltrim(rtrim(:earnp))",
empnop "ltrim(rtrim(:empnop))",
date1p "ltrim(rtrim(:date1p))",
hrsp "ltrim(rtrim(:hrsp))",
ratep "ltrim(rtrim(:ratep))",
amountp "ltrim(rtrim(:amountp))"
)