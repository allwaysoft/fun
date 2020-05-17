
OPTIONS (SKIP=3)

load data

infile '\\Accounting\D\CAD-USER\CMIC.CONV\dcpyempsecgrp.txt'

badfile 'cadcustom_pyempsecgrp.bad'

APPEND

into table DA.pyempsecgrp

fields terminated by ","  optionally enclosed by '"'

trailing nullcols

(
ESG_CODE,
ESG_NAME
)