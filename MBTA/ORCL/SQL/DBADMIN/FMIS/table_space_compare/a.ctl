OPTIONS (SKIP = 0, ERRORS = 1)
  
load data
infile 'C:\MISC\ORACLE\SQL\DBADMIN\FMIS\table_space_compare\a1.txt'
BADFILE 'C:\MISC\ORACLE\SQL\DBADMIN\FMIS\table_space_compare\a1_bad.bad'

TRUNCATE 
into table dbadmin.t
fields terminated by "," enclosed by '|'
TRAILING NULLCOLS              
(
a "substr(:a,1,3999)",
b "substr(:a,4000,7999)",
c "substr(:a,8000,length(:a))"
)