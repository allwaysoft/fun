@echo off
if [%1]==[] goto Usage
if [%2]==[] goto Usage
set srcDir=C:\mypath
set iniFile=%1
set tblName=%2
set dstFile=%srcDir%\loadit.bat
echo LOAD DATA>%dstFile%
echo INFILE '%srcDir%\%iniFile%'>>%dstFile%
echo APPEND INTO TABLE %tblName%>>%dstFile%
echo fields terminated by ',' optionally enclosed by '^"'>>%dstFile%
echo (>>%dstFile%
echo column1,>>%dstFile%
echo column2,>>%dstFile%
echo column3,>>%dstFile%
echo column4,>>%dstFile%
echo column5>>%dstFile%
echo )>>%dstFile%
call %dstFile%
goto :eof

:Usage
cls
Echo.  Two parameters must be supplied:
Echo.     -control file to be used
Echo.     -table name
Echo.
Echo. Usage:
Echo.   LoadSQL MyControl.Ctl MyTable
Echo.
