
load data

infile '\\Accounting\D\CAD-USER\CMIC.CONV\UETD\UETD_BUILDERSRI.txt'

badfile 'D:\cm\2006\Conversion\cadcustom_uetd_tables_files\cadcustom_uetd_buildersri.bad'

TRUNCATE

into table DA.UETD_BUILDERSRI

fields terminated by ","  optionally enclosed by '"'

trailing nullcols

(
	PROJ_SEQ,
	ATTACH_SEQ,
	PMBRREQ,
	PMBRPSTART	DATE "MM/DD/YYYY",
	PMBRPEND	DATE "MM/DD/YYYY",
	PMBRASTART	DATE "MM/DD/YYYY",
	PMBRAEND	DATE "MM/DD/YYYY"
)
