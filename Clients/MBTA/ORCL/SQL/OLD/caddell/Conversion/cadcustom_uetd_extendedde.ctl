

OPTIONS (SKIP=3)

load data

infile '\\Accounting\D\CAD-USER\CMIC.CONV\email.dd.txt'

badfile 'D:\cm\2006\Conversion\cadcustom_acct_files\email.dd.bad'

TRUNCATE

into table DA.UETD_EXTENDEDDE

fields terminated by ","  optionally enclosed by '"'

trailing nullcols

(
EMP_NUM,
ATTACH_SEQ,
PYEMAILDD,
PYEMAILAD
)
