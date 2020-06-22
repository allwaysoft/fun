
sqlldr.exe userid=%1 control = D:\cm\2006\Conversion\cadcustom_jcdeta_files\cadcustom_jcdeta_cc.ctl log = D:\cm\2006\Conversion\cadcustom_jcdeta_files\cadcustom_jcdeta_cc.log

ECHO EXIT | sqlplus %1 @D:\cm\2006\Conversion\cadcustom_jcdeta_files\cadcustom_jcdeta_cc_verify.sql

sqlldr.exe userid=%1 control = D:\cm\2006\Conversion\cadcustom_jcdeta_files\cadcustom_jcdeta_ac.ctl log = D:\cm\2006\Conversion\cadcustom_jcdeta_files\cadcustom_jcdeta_ac.log

ECHO EXIT | sqlplus %1 @D:\cm\2006\Conversion\cadcustom_jcdeta_files\cadcustom_jcdeta_ac_verify.sql