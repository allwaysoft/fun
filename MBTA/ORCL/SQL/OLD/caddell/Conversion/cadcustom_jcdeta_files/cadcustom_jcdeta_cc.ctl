
OPTIONS (SKIP=3)

load data

infile '\\Accounting\D\CAD-USER\CMIC.CONV\dcjcdetail.cc.txt'

badfile 'D:\cm\2006\Conversion\cadcustom_jcdeta_files\DCJCDETA_cc.bad'

TRUNCATE

into table DA.DC_JCDETAIL

fields terminated by ","  optionally enclosed by '"'

trailing nullcols

(
        DC_ROWNUM SEQUENCE(MAX,1),
	JCDT_REF_DATE	DATE		"YYYYMMDD",
	JCDT_POST_DATE	DATE		"YYYYMMDD",
	JCDT_BCH_NUM	,
	JCDT_UNIT	,
	JCDT_AMT	,
	JCDT_TYPE_CODE	"upper(rtrim(ltrim(:JCDT_TYPE_CODE)))",
	JCDT_JOB_CODE	"upper(rtrim(ltrim(:JCDT_JOB_CODE)))",
	JCDT_JOB_CTRL_CODE	"upper(rtrim(ltrim(:JCDT_JOB_CTRL_CODE)))",
	JCDT_REF_CODE	"upper(rtrim(ltrim(:JCDT_REF_CODE)))",
	JCDT_SRC_COMM_CODE	"upper(rtrim(ltrim(:JCDT_SRC_COMM_CODE)))",
	JCDT_SRC_CODE	"upper(rtrim(ltrim(:JCDT_SRC_CODE)))",
	JCDT_COMP_CODE	"upper(rtrim(ltrim(:JCDT_COMP_CODE)))",
	JCDT_DSRC_COMP_CODE	"upper(rtrim(ltrim(:JCDT_DSRC_COMP_CODE)))",
	JCDT_DSRC_CODE	"upper(rtrim(ltrim(:JCDT_DSRC_CODE)))",
	JCDT_JOUR_CODE	"upper(rtrim(ltrim(:JCDT_JOUR_CODE)))",
	JCDT_WM_CODE	"upper(rtrim(ltrim(:JCDT_WM_CODE)))",
	JCDT_SRC_DESC	"rtrim(ltrim(:JCDT_SRC_DESC))",
	JCDT_CAT_CODE	"upper(rtrim(ltrim(:JCDT_CAT_CODE)))",
	JCDT_CAT_CTRL_CODE	"upper(rtrim(ltrim(:JCDT_CAT_CTRL_CODE)))",
	JCDT_DEPT_CODE	"upper(rtrim(ltrim(:JCDT_DEPT_CODE)))",
	JCDT_REF_DESC	"rtrim(ltrim(:JCDT_REF_DESC))",
	JCDT_PHS_CODE	"upper(rtrim(ltrim(:JCDT_PHS_CODE)))",
	JCDT_PHS_CTRL_CODE	"upper(rtrim(ltrim(:JCDT_PHS_CTRL_CODE)))",
	JCDT_ACC_CODE	"upper(rtrim(ltrim(:JCDT_ACC_CODE)))",
        JCDT_INV_NUM	"upper(rtrim(ltrim(:JCDT_INV_NUM)))",
        JCDT_BILL_AMT	,
        JCDT_WBSV_CODE1	"upper(rtrim(ltrim(:JCDT_WBSV_CODE1)))",
        JCDT_WBSV_CODE2	"upper(rtrim(ltrim(:JCDT_WBSV_CODE2)))",
        JCDT_WBSV_CODE3	"upper(rtrim(ltrim(:JCDT_WBSV_CODE3)))",
        JCDT_WBSV_CODE4	"upper(rtrim(ltrim(:JCDT_WBSV_CODE4)))",
        JCDT_INV_BCH_NUM ,
        JCDT_AR_INV_NUM	"upper(rtrim(ltrim(:JCDT_AR_INV_NUM)))",
        JCDT_UNBILLED_REV_AMT	,
        JCDT_SEC_PAY_RUN "upper(rtrim(ltrim(:JCDT_SEC_PAY_RUN)))",
        JCDT_JB_DRAW_NUM ,
        JCDT_JB_REVISION_NUM ,
        JCDT_JB_DEFER_BILLING_FLAG "upper(rtrim(ltrim(:JCDT_JB_DEFER_BILLING_FLAG)))",
        JCDT_HOME_COMP_CODE	"upper(rtrim(ltrim(:JCDT_HOME_COMP_CODE)))",
        JCDT_HOME_DEPT_CODE	"upper(rtrim(ltrim(:JCDT_HOME_DEPT_CODE)))",
        JCDT_REV_GENERATED_AMT	,
        JCDT_CURR_CODE	"upper(rtrim(ltrim(:JCDT_CURR_CODE)))",
        JCDT_EXCHG_CURR_CODE	"upper(rtrim(ltrim(:JCDT_EXCHG_CURR_CODE)))",
        JCDT_EXCHG_RATE ,
        JCDT_EXCHG_AMT ,
        JCDT_BILL_CODE	"upper(rtrim(ltrim(:JCDT_BILL_CODE)))",
        JCDT_BILL_CODE_UPDATE_FLAG  "upper(rtrim(ltrim(:JCDT_BILL_CODE_UPDATE_FLAG)))",
        JCDT_POST_OVERHD_FLAG	"upper(rtrim(ltrim(:JCDT_POST_OVERHD_FLAG)))",
        JCDT_JB_DEFERRAL_DRAW_NUM ,
        JCDT_JB_DEFERRAL_REVISION_NUM,
	JCDT_SRC_CODE2	"upper(rtrim(ltrim(:JCDT_SRC_CODE2)))"

)
