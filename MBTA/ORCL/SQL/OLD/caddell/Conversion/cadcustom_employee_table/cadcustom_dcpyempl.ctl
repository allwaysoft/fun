
OPTIONS (SKIP=3)

load data

infile '\\Accounting\D\CAD-USER\CMIC.CONV\testloadingchkloc.txt'

badfile 'cadcustom_PYEMPL.bad'

TRUNCATE

into table DA1.PYEMPLOYEE_TABLE

fields terminated by ","  optionally enclosed by '"'

trailing nullcols

(

	EMP_NO	            "lpad(rtrim(ltrim(:EMP_NO)),5,0)",
        EMP_CKLOC_CODE      
)
