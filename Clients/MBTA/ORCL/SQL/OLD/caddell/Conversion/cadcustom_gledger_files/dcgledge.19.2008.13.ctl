
OPTIONS (SKIP=3)

load data

infile '\\Accounting\D\CAD-USER\CMIC.CONV\dcgledge.19.2008.13.txt'

badfile 'D:\cm\2006\Conversion\cadcustom_gledger_files\dcgledge.19.2008.13.bad'

TRUNCATE

into table DA.DC_GLEDGER

fields terminated by ","  optionally enclosed by '"'

trailing nullcols

(
        DC_ROWNUM SEQUENCE(MAX,1),
	GL_BCH_NUM	"upper(rtrim(ltrim(:GL_BCH_NUM)))",
	GL_COMP_CODE	"upper(rtrim(ltrim(:GL_COMP_CODE)))",
	GL_DEPT_CODE	"upper(rtrim(ltrim(:GL_DEPT_CODE)))",
	GL_ACC_CODE	"upper(rtrim(ltrim(:GL_ACC_CODE)))",
	GL_JOUR_CODE	"upper(rtrim(ltrim(:GL_JOUR_CODE)))",
	GL_SRC_CODE	"upper(rtrim(ltrim(:GL_SRC_CODE)))",
	GL_SRC_DESC	"rtrim(ltrim(:GL_SRC_DESC))",
	GL_REF_CODE	"upper(rtrim(ltrim(:GL_REF_CODE)))",
	GL_REF_DESC	"rtrim(ltrim(:GL_REF_DESC))",
	GL_REF_DATE	DATE		"YYYYMMDD",
	GL_POST_DATE	DATE		"YYYYMMDD",
	GL_AMT	,
	GL_WM_CODE	"upper(rtrim(ltrim(:GL_WM_CODE)))",
	GL_NUM	,
	GL_ADJ_YR ,
	GL_ADJ_PER ,
        GL_DSRC_COMP_CODE   "upper(rtrim(ltrim(:GL_DSRC_COMP_CODE)))",
        GL_CURR_CODE        "upper(rtrim(ltrim(:GL_CURR_CODE)))", 
        GL_TAV_CODE1        "upper(rtrim(ltrim(:GL_TAV_CODE1)))", 
        GL_TAV_CODE2        "upper(rtrim(ltrim(:GL_TAV_CODE2)))",
        GL_TAV_CODE3        "upper(rtrim(ltrim(:GL_TAV_CODE3)))",
        GL_TAV_CODE4        "upper(rtrim(ltrim(:GL_TAV_CODE4)))",
        GL_EXCHG_CURR_CODE  "upper(rtrim(ltrim(:GL_EXCHG_CURR_CODE)))",
        GL_EXCHG_RATE ,
        GL_EXCHG_AMT     ,
	GL_PYOVERHEAD_FLAG  
        
)
