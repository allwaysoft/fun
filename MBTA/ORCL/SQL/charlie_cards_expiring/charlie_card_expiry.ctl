OPTIONS (SKIP = 1, ERRORS = 1)
  
load data
infile 'C:\MISC\oracle\data\charlie_cards_expiring\input\CharlieCards_Active-20121210095057.csv' 
BADFILE 'C:\MISC\oracle\SQL\charlie_cards_expiring\CharlieCards_Active-20121210095057.bad'

TRUNCATE
into table mbta_temp_cards_expiring
fields terminated by "," optionally enclosed by '"'
TRAILING NULLCOLS             
(
CHARLIE_CARD_NO	"ltrim(rtrim(:CHARLIE_CARD_NO))"--,
--articleno "ltrim(rtrim(:articleno))",
--creadate "ltrim(rtrim(:creadate))"
)