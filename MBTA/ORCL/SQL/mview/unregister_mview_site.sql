-- do the below in the order specified below to unregister a mview site completly from the master site and purge the logs related to that mview site.
-- All the unregister and purge procedure below should be executed as repadmin user,unless otherwise mentioned.
-- Below, name of the mviewsite has to be changed accordingly.

exec DBMS_REPCAT.UNREGISTER_MVIEW_REPGROUP (gname => 'MBTA_REPG1',mviewsite => 'NWCD.STA10116');
exec DBMS_REPCAT.UNREGISTER_MVIEW_REPGROUP (gname => 'MBTA_REPG2',mviewsite => 'NWCD.STA10116');

  
select 'exec DBMS_MVIEW.PURGE_MVIEW_FROM_LOG (mviewowner => ''MBTA''' || ', mviewname => ''' || name || ''', mviewsite =>''' || MVIEW_SITE || ''');' 
from dba_registered_mviews where  MVIEW_SITE in ('NWCD.STA10116')
order by MVIEW_SITE,name;


select 'exec DBMS_MVIEW.UNREGISTER_MVIEW (mviewowner => ''MBTA''' || ', mviewname => ''' || name || ''', mviewsite =>''' || MVIEW_SITE || ''');' 
from dba_registered_mviews where  MVIEW_SITE in ('NWCD.STA10116')
order by MVIEW_SITE,name;
  
   
select distinct 'exec DBMS_MVIEW.PURGE_LOG (master=>''' ||name|| ''',num=>1, flag=>''delete'');' from dba_registered_mviews;  -- *** DO THIS AS MBTA USER.