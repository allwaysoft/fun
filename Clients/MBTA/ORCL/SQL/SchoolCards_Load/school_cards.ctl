OPTIONS (SKIP = 0, ERRORS = 1)
  
load data
infile 'C:\MISC\ORACLE\data\SchoolCards_Load\BPS_ExtraSVStudent2013.csv' 
BADFILE 'C:\MISC\oracle\data\SchoolCards_Load\BPS_ExtraSVStudent2013.bad'
--infile 'C:\MISC\oracle\data\SchoolCards_Load\student_cards_bps_oct_2012.csv' 
--BADFILE 'C:\MISC\oracle\data\SchoolCards_Load\student_cards_bps_oct_2012.bad'

APPEND

into table schoolcards
fields terminated by "," optionally enclosed by '"'
TRAILING NULLCOLS             
(
SEQUENCE	 "ltrim(rtrim(:SEQUENCE))",
CHARLIECARD	 "ltrim(rtrim(:CHARLIECARD))",
SCHOOLIDX	 "ltrim(rtrim(:SCHOOLIDX))",
BLOCKDATE	 "ltrim(rtrim(:BLOCKDATE))",
TYPEBLOCK	 "ltrim(rtrim(:TYPEBLOCK))",
ASSIGNED	 "ltrim(rtrim(:ASSIGNED))",
WHOBLOCKED	 "ltrim(rtrim(:WHOBLOCKED))",
DAYSVALID    "ltrim(rtrim(:DAYSVALID))",
ASSIGNEDTO	 "ltrim(rtrim(:ASSIGNEDTO))",
MONTHLYUSAGE "ltrim(rtrim(:MONTHLYUSAGE))"
)