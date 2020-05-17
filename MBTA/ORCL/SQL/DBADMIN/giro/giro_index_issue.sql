http://jonathanlewis.wordpress.com/2011/05/08/consistent-gets-3/
https://forums.oracle.com/forums/thread.jspa?threadID=1118578
https://kr.forums.oracle.com/forums/thread.jspa?threadID=2215037
https://forums.oracle.com/forums/thread.jspa?threadID=2366683&start=15&tstart=0

exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'GIRO', TABNAME => 'HASTUS_MEASURE', CASCADE => TRUE, ESTIMATE_PERCENT => NULL);

EXEC DBMS_MONITOR.session_trace_enable(session_id =>1056, serial_num=>36628, waits=>TRUE, binds=>TRUE);
EXEC DBMS_MONITOR.session_trace_enable(session_id =>1034, serial_num=>7268, waits=>TRUE, binds=>TRUE);

exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'MBTA', TABNAME => 'MBTA_WEEKEND_SERVICE', CASCADE => TRUE, ESTIMATE_PERCENT => NULL);