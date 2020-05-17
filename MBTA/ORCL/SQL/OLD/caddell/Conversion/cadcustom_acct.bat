
sqlldr.exe userid=%1 control = D:\cm\2006\Conversion\cadcustom_acct_files\cadcustom_acct1.ctl log = D:\cm\2006\Conversion\cadcustom_acct_files\cadcustom_acct1.log

ECHO EXIT | sqlplus %1 @D:\cm\2006\Conversion\cadcustom_acct_files\cadcustom_acct1_verify.sql

sqlldr.exe userid=%1 control = D:\cm\2006\Conversion\cadcustom_acct_files\cadcustom_acct2.ctl log = D:\cm\2006\Conversion\cadcustom_acct_files\cadcustom_acct2.log

ECHO EXIT | sqlplus %1 @D:\cm\2006\Conversion\cadcustom_acct_files\cadcustom_acct2_verify.sql

sqlldr.exe userid=%1 control = D:\cm\2006\Conversion\cadcustom_acct_files\cadcustom_acct3.ctl log = D:\cm\2006\Conversion\cadcustom_acct_files\cadcustom_acct3.log

ECHO EXIT | sqlplus %1 @D:\cm\2006\Conversion\cadcustom_acct_files\cadcustom_acct3_verify.sql