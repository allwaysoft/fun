

OPTIONS (SKIP=3)

load data

infile '\\Accounting\D\CAD-USER\CMIC.CONV\dcpyjoballoc.txt'

badfile 'DCPYJOBALLOC.bad'

TRUNCATE

into table DA.DC_PYJOBALLOC

fields terminated by ","  optionally enclosed by '"'

trailing nullcols

(
        DC_ROWNUM SEQUENCE(MAX,1),
	PYJA_COMP_CODE	"upper(rtrim(ltrim(:PYJA_COMP_CODE)))",
	PYJA_JOB_CODE	"upper(rtrim(ltrim(:PYJA_JOB_CODE)))",
	PYJA_TYPE_CODE	"upper(rtrim(ltrim(:PYJA_TYPE_CODE)))",
	PYJA_CODE	"upper(rtrim(ltrim(:PYJA_CODE)))",
	PYJA_CAT_CODE	"upper(rtrim(ltrim(:PYJA_CAT_CODE)))",
	PYJA_PHS_CODE   "upper(rtrim(ltrim(:PYJA_PHS_CODE)))"
)
