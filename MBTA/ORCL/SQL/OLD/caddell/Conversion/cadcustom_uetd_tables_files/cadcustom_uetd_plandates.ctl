
load data

infile '\\Accounting\D\CAD-USER\CMIC.CONV\UETD\UETD_PLANDATES.txt'

badfile 'D:\cm\2006\Conversion\cadcustom_uetd_tables_files\cadcustom_uetd_plandates.bad'

TRUNCATE

into table DA.UETD_PLANDATES

fields terminated by ","  optionally enclosed by '"'

trailing nullcols

(

PROJ_SEQ,
ATTACH_SEQ,
PMSCDATE   DATE "MM/DD/YYYY",
PMQCDATE   DATE "MM/DD/YYYY",
PMSAFDATE  DATE "MM/DD/YYYY",
PMENVDATE  DATE "MM/DD/YYYY",
PMSUBREGDT DATE "MM/DD/YYYY",
PM294DATE  DATE "MM/DD/YYYY"
)
