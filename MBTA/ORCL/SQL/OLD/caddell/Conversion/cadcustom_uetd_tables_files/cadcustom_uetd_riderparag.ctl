
load data

infile '\\Accounting\D\CAD-USER\CMIC.CONV\UETD\UETD_RIDERPARAG.txt'

badfile 'D:\cm\2006\Conversion\cadcustom_uetd_tables_files\cadcustom_uetd_riderparag.bad'

TRUNCATE

into table DA.UETD_RIDERPARAG

fields terminated by ","  optionally enclosed by '"'

trailing nullcols

(

	PROJ_SEQ,
	ATTACH_SEQ,
	PMOINSINS,
	PMOINSCANC,
	PMOINSAATT,
	PMOINSANAM,
	PMOINSAAD1,
	PMOINSAAD2,
	PMOINSACSZ,
)
