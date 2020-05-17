

OPTIONS (SKIP=3)

load data

infile '\\Accounting\D\CAD-USER\CMIC.CONV\DCACCNT.2.txt'

badfile 'D:\cm\2006\Conversion\cadcustom_acct_files\DCACCNT2.bad'


TRUNCATE

into table DA.DC_ACCOUNT

fields terminated by ","  optionally enclosed by '"'

trailing nullcols

(
        DC_ROWNUM SEQUENCE(MAX,1),
	ACC_CONSCHART_CODE	"upper(rtrim(ltrim(:ACC_CONSCHART_CODE)))",
	ACC_CODE	"upper(rtrim(ltrim(:ACC_CODE)))",
	ACC_NAME	"rtrim(ltrim(:ACC_NAME))",
	ACC_TYPE_CODE	"upper(rtrim(ltrim(:ACC_TYPE_CODE)))",
	ACC_CTRL_CODE	"upper(rtrim(ltrim(:ACC_CTRL_CODE)))",
	ACC_LONG_CODE	"upper(rtrim(ltrim(:ACC_LONG_CODE)))",
	ACC_SEQUENCE	"replace(:ACC_SEQUENCE,' ',NULL)",
	ACC_WM_CODE	"upper(rtrim(ltrim(:ACC_WM_CODE)))",
	ACC_NORMAL_BAL_CODE	"upper(rtrim(ltrim(:ACC_NORMAL_BAL_CODE)))",
	ACC_SUBLEDG_CODE	"upper(rtrim(ltrim(:ACC_SUBLEDG_CODE)))",
	ACC_SUMMARY_CODE	"upper(rtrim(ltrim(:ACC_SUMMARY_CODE)))",
	ACC_OF_CONCATENATED_SEGMENTS	"rtrim(ltrim(:ACC_OF_CONCATENATED_SEGMENTS))",
	ACC_INTER_COMP_ACC_FLAG	"upper(rtrim(ltrim(:ACC_INTER_COMP_ACC_FLAG)))",
	ACC_HIER	"rtrim(ltrim(:ACC_HIER))",
	ACC_LEVEL_CODE	"replace(:ACC_LEVEL_CODE,' ',NULL)",
	ACC_LOW_FLAG	"upper(rtrim(ltrim(:ACC_LOW_FLAG)))",
	ACC_TAV_CODE1	"upper(rtrim(ltrim(:ACC_TAV_CODE1)))",
	ACC_TAV_CODE2	"upper(rtrim(ltrim(:ACC_TAV_CODE2)))",
	ACC_TAV_CODE3	"upper(rtrim(ltrim(:ACC_TAV_CODE3)))",
	ACC_TAV_CODE4	"upper(rtrim(ltrim(:ACC_TAV_CODE4)))",
	ACC_TAV_REQUIRED_FLAG1	"upper(rtrim(ltrim(:ACC_TAV_REQUIRED_FLAG1)))",
	ACC_TAV_REQUIRED_FLAG2	"upper(rtrim(ltrim(:ACC_TAV_REQUIRED_FLAG2)))",
	ACC_TAV_REQUIRED_FLAG3	"upper(rtrim(ltrim(:ACC_TAV_REQUIRED_FLAG3)))",
	ACC_TAV_REQUIRED_FLAG4	"upper(rtrim(ltrim(:ACC_TAV_REQUIRED_FLAG4)))",
	ACC_TAV_VALIDATED_FLAG1	"upper(rtrim(ltrim(:ACC_TAV_VALIDATED_FLAG1)))",
	ACC_TAV_VALIDATED_FLAG2	"upper(rtrim(ltrim(:ACC_TAV_VALIDATED_FLAG2)))",
	ACC_TAV_VALIDATED_FLAG3	"upper(rtrim(ltrim(:ACC_TAV_VALIDATED_FLAG3)))",
	ACC_TAV_VALIDATED_FLAG4	"upper(rtrim(ltrim(:ACC_TAV_VALIDATED_FLAG4)))",
	ACC_TAV_EDITABLE_FLAG1	"upper(rtrim(ltrim(:ACC_TAV_EDITABLE_FLAG1)))",
	ACC_TAV_EDITABLE_FLAG2	"upper(rtrim(ltrim(:ACC_TAV_EDITABLE_FLAG2)))",
	ACC_TAV_EDITABLE_FLAG3	"upper(rtrim(ltrim(:ACC_TAV_EDITABLE_FLAG3)))",
	ACC_TAV_EDITABLE_FLAG4	"upper(rtrim(ltrim(:ACC_TAV_EDITABLE_FLAG4)))"
)
