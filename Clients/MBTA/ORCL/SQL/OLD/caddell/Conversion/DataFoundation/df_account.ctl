

load data

infile 'DF_ACCOUNT.txt'

badfile 'DF_ACCOUNT.bad'

TRUNCATE

into table DA.DF_ACCOUNT

fields terminated by ","  optionally enclosed by '"'

trailing nullcols

(
        DC_ROWNUM SEQUENCE(MAX,1),
	ACC_CONSCHART_CODE	"upper(rtrim(ltrim(:ACC_CONSCHART_CODE)))",
	ACC_CODE	"upper(rtrim(ltrim(:ACC_CODE)))",
	ACC_NAME	"rtrim(ltrim(:ACC_NAME))",
	ACC_CTRL_CODE	"upper(rtrim(ltrim(:ACC_CTRL_CODE)))",
	ACC_SEQUENCE	"replace(:ACC_SEQUENCE,' ',NULL)",
	ACC_LEVEL_CODE	"replace(:ACC_LEVEL_CODE,' ',NULL)",
	ACC_LOW_FLAG                   	
)
