spool rpsc07.log

SET ECHO ON

CONNECT SYSTEM/manager@mvdb


-- 1. Create materialized View administrator for replication
-- =========================================================


--create user MVIEWADMIN identified by MVIEWADMIN;

--GRANT
--	COMMENT ANY TABLE,
--	SELECT ANY DICTIONARY,
--	CREATE SESSION,
--	LOCK ANY TABLE
--TO mviewadmin;



-- 2. Grant appropriate privileges to materialized view administrator
-- ==================================================================

BEGIN
   DBMS_REPCAT_ADMIN.GRANT_ADMIN_ANY_SCHEMA (
      username => 'mviewadmin');
END;
/


-- 3. Register propagating the deferred transactions
-- ===================================================

BEGIN
   DBMS_DEFER_SYS.REGISTER_PROPAGATOR (
      username => 'mviewadmin');
END;
/


-- 4. Connect as materialized view administrator
-- =============================================

--CONNECT mviewadmin/mviewadmin@mvdb


-- 5. create database link to master site replication administrator
-- ===========================================================================

--CREATE DATABASE LINK nwcd.mbta.com;


-- 6. Connect as database user
-- ===========================

--CONNECT mbta/hallo@mvdb


-- 7. Drop and recreate database link to master site replication administrator
-- ===========================================================================

--CREATE DATABASE LINK nwcd.mbta.com;
--CREATE DATABASE LINK nwcd.masterdb;



-- 8. Connect as materialized view administrator
-- ==============================================

CONNECT mviewadmin/mviewadmin@mvdb


-- 9. Create the materialized view replication group
-- ==================================================

BEGIN
   DBMS_REPCAT.CREATE_MVIEW_REPGROUP (
      gname => 'mbta_repg1',
      master => 'nwcd.mbta.com',
      propagation_mode => 'ASYNCHRONOUS');
END;
/


-- 11. Create the refresh group (job)
-- ==================================

BEGIN
   DBMS_REFRESH.MAKE (
      name => 'mviewadmin.mbta_refg1',
      list => '', 
      next_date => SYSDATE, 
      interval => 'SYSDATE + 15/(60*24)',
      implicit_destroy => FALSE, 
      rollback_seg => '',
      push_deferred_rpc => TRUE, 
      refresh_after_errors => FALSE);
END;
/


-- 11. Change an existing refresh group
-- ====================================

BEGIN
   DBMS_REFRESH.CHANGE (
      name => 'mviewadmin.mbta_refg1',
      next_date => SYSDATE, 
      interval => 'SYSDATE + 15/(60*24)',
      implicit_destroy => FALSE, 
      rollback_seg => '',
      push_deferred_rpc => TRUE, 
      refresh_after_errors => FALSE);
END;
/


SET ECHO OFF
--exit;

