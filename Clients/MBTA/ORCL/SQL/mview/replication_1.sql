BEGIN
  sys.dbms_refresh.refresh
    (name => 'MVIEWADMIN.MBTA_REFG1');
END;

execute dbms_mview.refresh('"MBTA"."ALARMSERVERCONFIG"','C'); 

execute dbms_mview.refresh('"MBTA"."ACCESSLEVEL"','C');

SQL> execute DBMS_REFRESH.ADD(
    name => 'my_group_1',
    list => 'mv_borrowing_rate');


execute DBMS_REFRESH.SUBTRACT(name => 'MBTA_REFG1', list => 'MBTA.TVMSCHEDULEGROUPELEMENTS');




select * from DBA_REFRESH_CHILDREN

select 'execute dbms_mview.refresh(''"MBTA"."' || name || '"'',''C'');' from DBA_REFRESH_CHILDREN


select 'execute dbms_mview.refresh(''"MBTA"."' || mview_name || '"'',''C'');' from dba_mviews

select * from dba_mviews




begin
 dbms_refresh.add(
  name  => 'MBTA_REFG1',
  list  => 'mbta.dummy_snap');
end;


begin
 dbms_refresh.subtract(
  name  => 'MBTA_REFG1',
  list  => 'mbta.dummy_snap');
end;


EXEC DBMS_JOB.BROKEN(303,TRUE); 






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



exec DBMS_REFRESH.ADD(name => '"MVIEWADMIN"."MBTA_REFG1"', list => '"MBTA"."FUNDSPOOL"', lax => TRUE);

exec DBMS_REFRESH.ADD(name => '"MVIEWADMIN"."MBTA_REFG1"', list => '"MBTA"."FUNDSPOOLTVMRELATION"', lax => TRUE);