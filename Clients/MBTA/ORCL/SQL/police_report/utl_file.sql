
  CREATE OR REPLACE PROCEDURE "MBTA"."SP_POLICE_FILE_CSV_EXPORT_MBTA" 
as
v_output            utl_file.file_type;
v_Cursor       integer default dbms_sql.open_cursor;
v_columnValue   varchar2(4000);
v_status            integer;
v_query             varchar2(10000);
v_colCnt            number := 0;
v_separator       varchar2(1);
v_descTbl         dbms_sql.desc_tab;
v_dir                varchar2(200) default 'POLICE_INFO_EMAIL_DIR';
v_filename        varchar2(200);
begin

select  'Police_Information_'||to_char( sysdate, 'MON-YYYY' ) ||'.csv' into v_filename from dual;

v_query :=
'SELECT /*+ index(sd, XIE5SALESDETAIL) index(sd, XIE7SALESDETAIL) */
  POLICE_ID 
 , POLICE_SERIALNO 
 , Replace(POLICE_NAME,'','','' '') POLICE_NAME
 , sta.stationid                           STATION_ID
 , Replace(sta.name, '','', '' '')      STATION_NAME
 , sd.creadate                           CREATE_DATE
 FROM mbta_temp_police_information mtpi
 ,SalesDetail               sd
 ,SalesDetail               sub
 ,MiscCardMovement   mcm
 ,SalesTransaction       st
 ,TVMTable                 tvm
 ,tvmStation                sta
 WHERE  sd.ticketserialno = mtpi.POLICE_SERIALNO
 AND sub.DeviceClassId       (+)    = sd.DeviceClassId
 AND    sub.DeviceId               (+)    = sd.DeviceId
 AND    sub.Uniquemsid             (+)    = sd.Uniquemsid
 AND    sub.SalestransactionNo    (+)    = sd.SalesTransactionNo
 AND    sub.SalesDetailEvSequNo    (+)    = sd.SalesDetailEvSequNo    +1
 AND    sub.CorrectionCounter    (+)    = sd.CorrectionCounter
 AND    sub.PartitioningDate    (+)    = sd.PartitioningDate
 AND    mcm.DeviceClassId           = sd.DeviceClassId
 AND    mcm.DeviceId                   = sd.DeviceId
 AND    mcm.Uniquemsid                 = sd.Uniquemsid
 AND    mcm.SalestransactionNo        = sd.SalesTransactionNo
 AND    mcm.SequenceNo                = Decode    (sub.SalesDetailEvSequNo
                                                    ,NULL    ,sd.SalesDetailEvSequNo
                                                    ,sub.SalesDetailEvSequNo
                                                 )
 AND  mcm.CorrectionCounter        = sd.CorrectionCounter
 AND  mcm.PartitioningDate        = sd.PartitioningDate
 AND  mcm.TimeStamp                = sd.CreaDate
 AND  st.DeviceID =  mcm.DeviceID
 AND  st.DeviceClassID =  mcm.DeviceClassID
 AND  st.UniqueMSID = mcm.UniqueMSID          
 AND  st.SalesTransactionNo =  mcm.SalesTransactionNo
 AND  st.PartitioningDate = mcm.PartitioningDate 
 AND  tvm.TVMID            =    st.DeviceID
 AND  tvm.DeviceClassID    =    st.DeviceClassID
 AND  sta.StationID     (+)    =    tvm.TVMTariffLocationID
 AND  mcm.MovementType   IN     (7)
 AND  sd.ArticleNo                >     100000
 AND  sd.CorrectionFlag        =     0
 AND  sd.RealStatisticArticle  =     0
 AND  sd.TempBooking         =     0
 AND  sd.ArticleNo                <>     607900100
 AND  sd.ticketstocktype        = 5
 AND  sub.ArticleNo         (+) =    607900100
 AND  st.TestSaleFlag           =     0
 AND sd.CreaDate >= to_date(sysdate-1000, ''MM-DD-YYYY-HH24-MI-SS'')
 AND sd.CreaDate < to_date(sysdate-999, ''MM-DD-YYYY-HH24-MI-SS'')
 AND sd.PartitioningDate >= to_date(sysdate-1000, ''MM-DD-YYYY-HH24-MI-SS'')
 AND sd.PartitioningDate < to_date(sysdate-990, ''MM-DD-YYYY-HH24-MI-SS'') 
 ORDER BY POLICE_ID, POLICE_SERIALNO, POLICE_NAME, sta.stationid, sta.name, sd.creadate';

--dbms_output.put_line (1);
sp_output_mbta(v_query);

v_output := utl_file.fopen( v_dir, v_filename, 'w' );
--execute immediate 'alter session set nls_date_format=''dd-mon-yyyy hh24:mi:ss'' ';

dbms_sql.parse(  v_Cursor,  v_query, dbms_sql.native );
dbms_sql.describe_columns( v_Cursor, v_colCnt, v_descTbl );

 for i in 1 .. v_colCnt loop
 utl_file.put( v_output, v_separator || v_descTbl(i).col_name );
 dbms_sql.define_column( v_Cursor, i, v_columnValue, 4000 );
 v_separator := ',';
 end loop;
 utl_file.new_line( v_output );
 
 v_status := dbms_sql.execute(v_Cursor);
 
 while ( dbms_sql.fetch_rows(v_Cursor) > 0 ) loop
 v_separator := '';
 for i in 1 .. v_colCnt loop
 dbms_sql.column_value( v_Cursor, i, v_columnValue );
 utl_file.put( v_output, v_separator || v_columnValue );
 v_separator := ',';
 end loop;
 utl_file.new_line( v_output );
 end loop;
 dbms_sql.close_cursor(v_Cursor);
 utl_file.fclose( v_output );
   
 --execute immediate 'alter session set nls_date_format=''dd-MON-yy'' ';
 exception
      when utl_file.invalid_path then
         raise_application_error(-20100,'Invalid Path');
      when utl_file.invalid_mode then
         raise_application_error(-20101,'Invalid Mode');
      when utl_file.invalid_operation then
         raise_application_error(-20102,'Invalid Operation');
      when utl_file.invalid_filehandle then
         raise_application_error(-20103,'Invalid FileHandle');
      when utl_file.write_error then
         raise_application_error(-20104,'Write Error');
      when utl_file.read_error then
         raise_application_error(-20105,'Read Error');
      when utl_file.internal_error then
         raise_application_error(-20106,'Internal Error');
      when others then
           utl_file.fclose( v_output );
           raise;
end;
/
 
