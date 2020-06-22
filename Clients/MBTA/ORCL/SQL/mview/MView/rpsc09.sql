spool rpsc09.log
set echo on


-- 1. Connect as materialized view administrator
-- =============================================

CONNECT mviewadmin/mviewadmin@mvdb

-- 2. Create all replication object
-- ================================

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'ACCESSLEVEL',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'ALARMACTION',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'ALARMEVENT',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'ALARMSERVERCONFIG',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'ALARMSERVERGROUP',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/


-- 5  ########################################

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'ALARMSERVERGROUP_ALARMEVENT',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'ARTICLE',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'ARTICLE_RELEASE',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'BALANCEGROUP',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'CASHTYPE',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/


-- 10  ########################################

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'COMPANY',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'CURRENCIES',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'DBCONNECTPARAMETER',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'DEFAULTSTATIONGROUP',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'DEVICECLASS',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/


-- 15  ########################################

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'DEVICECLASS_VERSIONS',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'DEVICECONFIG',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'EVENT',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'EVENTGROUP',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'FEPDATA',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/


-- 20  ########################################

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'FUNCTION',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'FUNCTIONGROUP',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'FUNDSPOOL',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'FUNDSPOOLTVMRELATION',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'GRAPHICMAP',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'GRAPHICPROPERTY',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'HARDWARECOMPONENTS',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/


-- 25  ########################################

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'JOBTABLE',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'LOCKDEPENDENCIES',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'MASTERASSEMBLY',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'MENUTREE',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/


BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'MULTIMEDIAGROUP',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/


-- 30  ########################################

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'ORAERR',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'PAYMENTCASHTYPE',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'PAYMENTOPDATA',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'PERMDETAIL',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'PERMISSION',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/


-- 35  ########################################

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'PREVIOUSPASSWORD',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'PREVIOUSPIN',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'RELEASE',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'RELEASE_VERSIONS',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'ROUTES',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/


-- 40  ########################################

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'SCHEDULEELEMENT',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'SCHEDULEGROUP',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'SCHEDULEGROUPELEMENTS',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'SCTVMRELATION',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'SDRELEASE',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/


-- 45  ########################################

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'SDRELEASE_RELEASE',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'STATIONCONTROLLER',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'STATUSOPTIONS',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'TABLEINFO',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'TARIFFVERSIONS',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/


-- 50  ########################################

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'TVMFEPGROUP',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'TVMGROUP',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'TVMNETCONFGROUP',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'TVMSCHEDULEGROUPELEMENT',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

--BEGIN
--  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
  --    gname => 'mbta_repg1',
    --  sname => 'MBTA',
--      oname => 'TVMSCHEDULEGROUPELEMENTS',
  --    type => 'SNAPSHOT',
    --  min_communication => TRUE);
--END;
--/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'TVMSTATION',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/


-- 55  ########################################

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'TVMTABLE',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'TVMVERSIONGROUP',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'UNIQUENUMBERS',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'USERDATA',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'USERGROUPS',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/


-- 60  ########################################

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'VERSIONGROUPLIST',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'VERSIONS',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'WORKSTATIONGRP',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'WORKSTATIONS',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/

BEGIN
  DBMS_REPCAT.CREATE_MVIEW_REPOBJECT(
      gname => 'mbta_repg1',
      sname => 'MBTA',
      oname => 'WSGRPCONTENTS',
      type => 'SNAPSHOT',
      min_communication => TRUE);
END;
/


-- 65  ########################################


-- 3. Add the defined objects to the refresh group
-- ===============================================

BEGIN
  DBMS_REFRESH.ADD (
      name => 'mviewadmin.mbta_refg1',
      list => ' 
              MBTA.ACCESSLEVEL 
              ,MBTA.ALARMACTION 
              ,MBTA.ALARMEVENT 
              ,MBTA.ALARMSERVERCONFIG 
              ,MBTA.ALARMSERVERGROUP 
              ,MBTA.ALARMSERVERGROUP_ALARMEVENT 
              ,MBTA.ARTICLE 
              ,MBTA.ARTICLE_RELEASE 
              ,MBTA.BALANCEGROUP 
              ,MBTA.CASHTYPE 
              ,MBTA.COMPANY 
              ,MBTA.CURRENCIES 
              ,MBTA.DBCONNECTPARAMETER 
              ,MBTA.DEFAULTSTATIONGROUP 
              ,MBTA.DEVICECLASS 
              ,MBTA.DEVICECLASS_VERSIONS 
              ,MBTA.DEVICECONFIG 
              ,MBTA.EVENT 
              ,MBTA.EVENTGROUP 
              ,MBTA.FEPDATA 
              ,MBTA.FUNCTION 
              ,MBTA.FUNCTIONGROUP
              ,MBTA.FUNDSPOOL
              ,MBTA.FUNDSPOOLTVMRELATION
              ,MBTA.GRAPHICMAP 
              ,MBTA.GRAPHICPROPERTY 
              ,MBTA.HARDWARECOMPONENTS 
              ,MBTA.JOBTABLE 
              ,MBTA.LOCKDEPENDENCIES 
              ,MBTA.MASTERASSEMBLY 
              ,MBTA.MENUTREE 
              ,MBTA.MULTIMEDIAGROUP 
              ,MBTA.ORAERR 
              ,MBTA.PAYMENTCASHTYPE 
              ,MBTA.PAYMENTOPDATA 
              ,MBTA.PERMDETAIL 
              ,MBTA.PERMISSION 
              ,MBTA.PREVIOUSPASSWORD 
              ,MBTA.PREVIOUSPIN 
              ,MBTA.RELEASE 
              ,MBTA.RELEASE_VERSIONS 
              ,MBTA.ROUTES 
              ,MBTA.SCHEDULEELEMENT 
              ,MBTA.SCHEDULEGROUP 
              ,MBTA.SCHEDULEGROUPELEMENTS 
              ,MBTA.SCTVMRELATION 
              ,MBTA.SDRELEASE 
              ,MBTA.SDRELEASE_RELEASE 
              ,MBTA.STATIONCONTROLLER 
              ,MBTA.STATUSOPTIONS 
              ,MBTA.TABLEINFO 
              ,MBTA.TARIFFVERSIONS 
              ,MBTA.TVMFEPGROUP 
              ,MBTA.TVMGROUP 
              ,MBTA.TVMNETCONFGROUP 
              ,MBTA.TVMSCHEDULEGROUPELEMENT
              --,MBTA.TVMSCHEDULEGROUPELEMENTS 
              ,MBTA.TVMSTATION 
              ,MBTA.TVMTABLE 
              ,MBTA.TVMVERSIONGROUP 
              ,MBTA.UNIQUENUMBERS 
              ,MBTA.USERDATA 
              ,MBTA.USERGROUPS 
              ,MBTA.VERSIONGROUPLIST 
              ,MBTA.VERSIONS 
              ,MBTA.WORKSTATIONGRP 
              ,MBTA.WORKSTATIONS 
              ,MBTA.WSGRPCONTENTS 
              ',
      lax => TRUE);
END;
/

spool off
--exit
