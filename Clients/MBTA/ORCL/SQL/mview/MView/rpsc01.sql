spool rpsc01.log
set echo on


-- Connect as materialized view administrator
-- =============================================

CONNECT mviewadmin/mviewadmin@mvdb

-- Remove all Objects from Refresh Group
-- =============================================
-- #1 ------------------------------------------
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."MULTIMEDIAGROUP"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."ACCESSLEVEL"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."ALARMACTION"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."ALARMEVENT"',
     lax => TRUE);
END;
/

-- #5 ------------------------------------------
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."ALARMSERVERCONFIG"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."ALARMSERVERGROUP"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."ALARMSERVERGROUP_ALARMEVENT"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."ARTICLE"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."ARTICLE_RELEASE"',
     lax => TRUE);
END;
/

-- #10 ------------------------------------------
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."BALANCEGROUP"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."CASHTYPE"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."COMPANY"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."CURRENCIES"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."DBCONNECTPARAMETER"',
     lax => TRUE);
END;
/

-- #15 ------------------------------------------
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."DEFAULTSTATIONGROUP"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."DEVICECLASS"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."DEVICECLASS_VERSIONS"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."DEVICECONFIG"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."EVENT"',
     lax => TRUE);
END;
/

-- #20 ------------------------------------------
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."EVENTGROUP"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."FEPDATA"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."FUNCTION"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."FUNCTIONGROUP"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."FUNDSPOOL"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."FUNDSPOOLTVMRELATION"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."GRAPHICMAP"',
     lax => TRUE);
END;
/

-- #25 ------------------------------------------
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."GRAPHICPROPERTY"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."HARDWARECOMPONENTS"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."JOBTABLE"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."LOCKDEPENDENCIES"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."MASTERASSEMBLY"',
     lax => TRUE);
END;
/

-- #30 ------------------------------------------
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."MENUTREE"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."ORAERR"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."PAYMENTCASHTYPE"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."PAYMENTOPDATA"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."PERMDETAIL"',
     lax => TRUE);
END;
/

-- #35 ------------------------------------------
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."PERMISSION"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."PREVIOUSPASSWORD"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."PREVIOUSPIN"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."RELEASE"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."RELEASE_VERSIONS"',
     lax => TRUE);
END;
/

-- #40 ------------------------------------------
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."ROUTES"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."SCHEDULEELEMENT"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."SCHEDULEGROUP"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."SCHEDULEGROUPELEMENTS"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."SCTVMRELATION"',
     lax => TRUE);
END;
/

-- #45 ------------------------------------------
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."SDRELEASE"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."SDRELEASE_RELEASE"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."STATIONCONTROLLER"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."STATUSOPTIONS"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."TABLEINFO"',
     lax => TRUE);
END;
/

-- #50 ------------------------------------------
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."TARIFFVERSIONS"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."TVMFEPGROUP"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."TVMGROUP"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."TVMNETCONFGROUP"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."TVMSCHEDULEGROUPELEMENT"',
     lax => TRUE);
END;
/

-- #55 ------------------------------------------
--BEGIN
  -- DBMS_REFRESH.SUBTRACT(
    -- name => '"MVIEWADMIN"."MBTA_REFG1"',
--     list => '"MBTA"."TVMSCHEDULEGROUPELEMENTS"',
  --   lax => TRUE);
--END;
--/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."TVMSTATION"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."TVMTABLE"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."TVMVERSIONGROUP"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."UNIQUENUMBERS"',
     lax => TRUE);
END;
/

-- #60 ------------------------------------------
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."USERDATA"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."USERGROUPS"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."VERSIONGROUPLIST"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."VERSIONS"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."WORKSTATIONGRP"',
     lax => TRUE);
END;
/

-- #65 ------------------------------------------
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."WORKSTATIONS"',
     lax => TRUE);
END;
/
BEGIN
   DBMS_REFRESH.SUBTRACT(
     name => '"MVIEWADMIN"."MBTA_REFG1"',
     list => '"MBTA"."WSGRPCONTENTS"',
     lax => TRUE);
END;
/



-- Remove Refresh Group
-- =============================================
BEGIN
   DBMS_REFRESH.DESTROY(name => '"MVIEWADMIN"."MBTA_REFG1"');
END;
/


spool off
--exit
