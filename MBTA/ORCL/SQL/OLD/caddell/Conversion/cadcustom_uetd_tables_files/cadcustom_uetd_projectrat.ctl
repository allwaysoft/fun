
load data

infile '\\Accounting\D\CAD-USER\CMIC.CONV\UETD\UETD_PROJECTRAT.txt'

badfile 'D:\cm\2006\Conversion\cadcustom_uetd_tables_files\cadcustom_uetd_projectrat.bad'

TRUNCATE

into table DA.UETD_PROJECTRAT

fields terminated by ","  optionally enclosed by '"'

trailing nullcols

(

PROJ_SEQ,
ATTACH_SEQ,
PMRATING,
PMAWARDS,
PMRECOMM

)
