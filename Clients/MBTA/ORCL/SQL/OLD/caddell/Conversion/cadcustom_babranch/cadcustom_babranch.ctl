
OPTIONS (SKIP=3)

load data

infile '\\Accounting\D\CAD-USER\CMIC.CONV\babranch.txt'

badfile 'BABRANCH.bad'

APPEND

into table DA.BABRANCH

fields terminated by ","  optionally enclosed by '"'

trailing nullcols

(
  BRN_BANK_CODE,
  BRN_BRANCH_CODE,
  BRN_BRANCH_NAME,
  BRN_SHORT_NAME,
  BRN_USER,
  BRN_LAST_UPD_DATE,
  BRN_SADDR_ORASEQ,
  BRN__IU__CREATE_DATE,
  BRN__IU__CREATE_USER,
  BRN__IU__UPDATE_DATE,
  BRN__IU__UPDATE_USER
)