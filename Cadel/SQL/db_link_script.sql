-- Script for Database Link to Conv

create public database link 
  CONV
connect to da
identified by da 
using 'CONV'

/

-- Script for Database Link to Prod

create public database link 
  PROD
connect to da
identified by da 
using 'PROD'

/


-- Script for Database Link to Test

create public database link 
  TEST
connect to da
identified by da 
using 'TEST'

/