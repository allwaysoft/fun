@echo off

set JDK_ROOT=D:\oracle\10gclient\jdk\jre
set ORACLE_HOME=D:\oracle\10gclient

set JLIBDIR=%ORACLE_HOME%\jlib
set LIBDIR=%ORACLE_HOME%\lib
set JDBCDIR=%ORACLE_HOME%\jdbc\lib
set OJLIBDIR=%ORACLE_HOME%\olap\jlib

set EWT=%JLIBDIR%\share.jar;%JLIBDIR%\ewt3.jar;%JLIBDIR%\ewt3-nls.jar
set JEWT4=%JLIBDIR%\jewt4.jar;%JLIBDIR%\jewt4-nls.jar;%JLIBDIR%\jle3.jar;%JLIBDIR%\jle3-nls.jar;%JLIBDIR%\dbui4.jar;%JLIBDIR%\dbui4-nls.jar
set KODIAK=%JLIBDIR%\kodiak.jar
set JDBC2=%JDBCDIR%\classes12.jar;%JDBCDIR%\nls_charset12.jar
set OHJ4=%JLIBDIR%\help4.jar;%JLIBDIR%\help4-nls.jar
set ICE=%JLIBDIR%\oracle_ice.jar
set OEM=%JLIBDIR%\oembase-10_1_0.jar;%JLIBDIR%\oemtools-10_1_0.jar
set API1=%OJLIBDIR%\collections.jar
set APACHE_COMMONS=%OJLIBDIR%\commons-collections-3.0.jar 


set API2=%ORACLE_HOME%\olap\api\lib\olap_api.jar;%ORACLE_HOME%\olap\api\lib\olap_api_spl.jar
set API3=%ORACLE_HOME%\olap\api\lib\awxml.jar
set GDK4=%JLIBDIR%\orai18n-utility.jar;%JLIBDIR%\orai18n-mapping.jar;%JLIBDIR%\orai18n-translation.jar;%JLIBDIR%\orai18n-collation.jar
set WKS=%OJLIBDIR%\xsjwork.jar
set DISCO=%OJLIBDIR%\jdiscoe.jar

set AWM=%OJLIBDIR%\awm.jar;%OJLIBDIR%\awmdep.zip;%OJLIBDIR%\awmhelp.jar;%LIBDIR%\xmlparserv2.jar;%LIBDIR%\xmlcomp.jar


set START=oracle.olap.awm.app.AwmApp
set CLASSPATH=%OEM%;%EWT%;%JEWT4%;%KODIAK%;%JDBC2%;%AWM%;%OHJ4%;%ICE%;%DISCO%;%API1%;%API2%;%API3%;%GDK4%;%WKS%;%APACHE_COMMONS%
set JAVA_RT=%JDK_ROOT%\bin\java

cd %ORACLE_HOME%\olap\awm
%JAVA_RT% -mx512m -Dsun.java2d.noddraw=true -DORACLE_HOME=D:\oracle\10gclient -cp %CLASSPATH% %START% %1 %2 %3 %4 %5 %6 %7 %8 %9 > awmrun.log
