
load data

infile '\\Accounting\D\CAD-USER\CMIC.CONV\UETD\UETD_PROJECTSTA.txt'

badfile 'D:\cm\2006\Conversion\cadcustom_uetd_tables_files\cadcustom_uetd_projectsta.bad'

TRUNCATE

into table DA.UETD_PROJECTSTA

fields terminated by ","  optionally enclosed by '"'

trailing nullcols

(

PROJ_SEQ,
ATTACH_SEQ,
PMAWARDDAT DATE "MM/DD/YYYY",
PMNTPDATE  DATE "MM/DD/YYYY",
PMLIQDAM,
PMCONTDUR,
PMORCOMPDT DATE "MM/DD/YYYY",
PMCRCOMPDT DATE "MM/DD/YYYY",
PMSBCOMPDT DATE "MM/DD/YYYY",
PMPCTCOMP,
PMPCTSELFP

)
