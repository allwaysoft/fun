
OPTIONS (SKIP=2)

load data

infile 'D:\table_exports\PYCOMPAYGRP.txt'

badfile 'PYCOMPAYGRP.bad'

APPEND

into table DA.PYCOMPAYGRP

fields terminated by ","  optionally enclosed by '"'

trailing nullcols

(
  PYG_COMP_CODE,
  PYG_CODE,
  PYG_DESCRIPTION,
  PYG_SHORT_DESC,
  PYG_BANK_CODE,
  PYG_BRANCH_CODE,
  PYG_BANK_ACC_NUMBER,
  PYG_CR_ACC_CODE,
  PYG_USER,
  PYG_LAST_UPD_DATE,
  PYG_DEPT_CODE,
  PYG_SIGN_FILE1,
  PYG_SIGN_FILE2,
  PYG_COMPANY_LOGO_FILE,
  PYG_PRINT_ADDRESS_FLAG,
  PYG_SECURE_FLAG,
  PYG_AMT_FOR_MANUAL_SIGN,
  PYG_AMT_FOR_TWO_SIGN,
  PYG_MESSAGE--,
  --PYG__IU__CREATE_DATE,
  --PYG__IU__CREATE_USER,
  --PYG__IU__UPDATE_DATE,
  --PYG__IU__UPDATE_USER
)