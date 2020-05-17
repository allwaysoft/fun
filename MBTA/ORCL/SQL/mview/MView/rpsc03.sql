spool rpsc03.log
set echo on


-- Connect as materialized view administrator
-- =============================================

CONNECT mviewadmin/mviewadmin@mvdb

-- Remove all snapshots objects
-- =============================================
-- #1 ------------------------------------------
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"ACCESSLEVEL"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"ALARMACTION"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"ALARMEVENT"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"ALARMSERVERCONFIG"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/

-- #5 ------------------------------------------
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"ALARMSERVERGROUP"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"ALARMSERVERGROUP_ALARMEVENT"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"ARTICLE"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"ARTICLE_RELEASE"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"BALANCEGROUP"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/

-- #10 ------------------------------------------
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"CASHTYPE"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"COMPANY"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"CURRENCIES"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"DBCONNECTPARAMETER"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"DEFAULTSTATIONGROUP"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/

-- #15 ------------------------------------------
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"DEVICECLASS"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"DEVICECLASS_VERSIONS"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"DEVICECONFIG"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"EVENT"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"EVENTGROUP"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/

-- #20 ------------------------------------------
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"FEPDATA"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"FUNCTION"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"FUNCTIONGROUP"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"GRAPHICMAP"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"GRAPHICPROPERTY"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/

-- #25 ------------------------------------------
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"HARDWARECOMPONENTS"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"JOBTABLE"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"LOCKDEPENDENCIES"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"MASTERASSEMBLY"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"MENUTREE"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/

-- #30 ------------------------------------------
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"MULTIMEDIAGROUP"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"ORAERR"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"PAYMENTCASHTYPE"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"PAYMENTOPDATA"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"PERMDETAIL"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/

-- #35 ------------------------------------------
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"PERMISSION"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"PREVIOUSPASSWORD"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"PREVIOUSPIN"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"RELEASE"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"RELEASE_VERSIONS"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/

-- #40 ------------------------------------------
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"ROUTES"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"SCHEDULEELEMENT"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"SCHEDULEGROUP"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"SCHEDULEGROUPELEMENTS"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"SCTVMRELATION"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/

-- #45 ------------------------------------------
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"SDRELEASE"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"SDRELEASE_RELEASE"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"STATIONCONTROLLER"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"STATUSOPTIONS"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"TABLEINFO"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/

-- #50 ------------------------------------------
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"TARIFFVERSIONS"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"TVMFEPGROUP"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"TVMGROUP"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"TVMNETCONFGROUP"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"TVMSCHEDULEGROUPELEMENT"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/

-- #55 ------------------------------------------
--BEGIN
  -- DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
    -- oname => '"TVMSCHEDULEGROUPELEMENTS"',
    -- type => 'SNAPSHOT',
     --sname => '"MBTA"',
     --drop_objects => FALSE);
--END;
--/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"TVMSTATION"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"TVMTABLE"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"TVMVERSIONGROUP"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"UNIQUENUMBERS"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/

-- #60 ------------------------------------------
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"USERDATA"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"USERGROUPS"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"VERSIONGROUPLIST"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"VERSIONS"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"WORKSTATIONGRP"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/

-- #65 ------------------------------------------
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"WORKSTATIONS"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"WSGRPCONTENTS"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"FUNDSPOOL"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPOBJECT(
     oname => '"FUNDSPOOLTVMRELATION"',
     type => 'SNAPSHOT',
     sname => '"MBTA"',
     drop_objects => FALSE);
END;
/

-- Remove snapshot Group
-- =============================================
BEGIN
   DBMS_REPCAT.DROP_SNAPSHOT_REPGROUP(
     gname => '"MBTA_REPG1"',
     drop_contents => TRUE);
END;
/


spool off
--exit
