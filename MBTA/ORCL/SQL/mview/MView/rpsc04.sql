spool rpsc04.log

SET ECHO ON


CONNECT mviewadmin/mviewadmin@mvdb

-- Drop database link to master site replication administrator
-- ===========================================================================

--DROP DATABASE LINK nwcd.mbta.com;


BEGIN
   DBMS_REPCAT.DROP_MVIEW_REPGROUP (
      gname => 'mbta_repg1',
      drop_contents => true,
      gowner => 'PUBLIC');
END;
/

CONNECT SYSTEM/manager@mvdb

--DROP PUBLIC DATABASE LINK nwcd.mbta.com;

-- Revoke appropriate privileges from materialized view administrator
-- =====================================================================

--BEGIN
--   DBMS_REPCAT_ADMIN.REVOKE_ADMIN_ANY_SCHEMA (
--      username => 'mviewadmin');
--END;
--/


-- Unregister propagating the deferred transactions
-- ===================================================

BEGIN
   DBMS_DEFER_SYS.UNREGISTER_PROPAGATOR (
      username => 'mviewadmin');
END;
/

-- drop materialized View administrator for replication
-- =========================================================

--Drop user MVIEWADMIN cascade;


--CONNECT mbta/hallo@mvdb


-- Drop database link to master site replication administrator
-- ===========================================================================

--drop database link nwcd.mbta.com;
--DROP DATABASE LINK nwcd.masterdb;

-- Connect as materialized view administrator
-- ==============================================

--CONNECT mviewadmin/mviewadmin@mvdb


-- Drop the materialized view replication group
-- ================================================



spool off
--exit;
