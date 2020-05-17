CREATE OR REPLACE PROCEDURE MBTA."SP_EMAIL_POLICE_INFO_MBTA" 
is
--declare
vconn            utl_smtp.connection;
vfilename       varchar2(200);
vemail_body   varchar2(32767);
crlf                varchar2(2):= chr(13) || chr(10);
vsql_stmt       varchar2(32767);
vcol_header    varchar2(200);
vstart_date     varchar2(20);
vend_date      varchar2(20);
vend_partition varchar2(20);
vqueryid         number(10);

procedure sp_send_header_mbta(name in varchar2, header in varchar2) as
begin
utl_smtp.write_data(vconn, name || ': ' || header || utl_tcp.crlf);
end;

  begin

  select s_queryresult.nextval into vqueryid from dual;

  vstart_date := to_char(trunc(add_months(sysdate,-2),'MM'), 'mm-dd-yyyy-hh24-mi-ss');
  vend_date     := to_char(trunc(add_months(sysdate,-1),'MM'), 'mm-dd-yyyy-hh24-mi-ss');
  vend_partition   := to_char(trunc(sysdate,'MM'), 'mm-dd-yyyy-hh24-mi-ss');

  vsql_stmt :=' 
  INSERT INTO MBTA_TEMPRESULT
  (
     QueryID
    ,LineId
    ,number1		
    ,number2		
    ,Data1		
    ,Data2		
    ,Data3		
    ,datetime1
  )
  SELECT /*+ index(sd, XIE5SALESDETAIL) index(sd, XIE7SALESDETAIL) */
   %VQUERYID%
  , 1
  , POLICE_ID 
  , POLICE_SERIALNO 
  , Replace(POLICE_NAME,'','','' '') POLICE_NAME
  , sta.stationid                           STATION_ID
  , Replace(sta.name, '','', '' '')      STATION_NAME
  , sd.creadate    CREATE_DATE
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
 AND sd.CreaDate >= to_date(''%VSTART_DATE%'', ''MM-DD-YYYY-HH24-MI-SS'')
 AND sd.CreaDate < to_date(''%VEND_DATE%'', ''MM-DD-YYYY-HH24-MI-SS'')
 AND sd.PartitioningDate >= to_date(''%VSTART_DATE%'', ''MM-DD-YYYY-HH24-MI-SS'')
 AND sd.PartitioningDate < to_date(''%VEND_PARTITION%'', ''MM-DD-YYYY-HH24-MI-SS'') 
 order by police_id, police_serialno, police_name, sta.stationid, sta.name, sd.creadate';

  vsql_stmt := replace (upper(vsql_stmt),'%VQUERYID%',vqueryid);
  vsql_stmt := replace (upper(vsql_stmt),'%VSTART_DATE%',vstart_date);
  vsql_stmt := replace (upper(vsql_stmt),'%VEND_DATE%',vend_date);
  vsql_stmt := replace (upper(vsql_stmt),'%VEND_PARTITION%',vend_partition);

  sp_output_mbta(vsql_stmt);

  execute immediate vsql_stmt;

--select  'police_info_'||to_char( add_months(sysdate, -2),  'mon_yyyy' ) ||'.csv' into vfilename from dual;

  vfilename := 'police_info_'||to_char( add_months(sysdate, -2),  'mon_yyyy' ) ||'.csv';

  vcol_header := 'police_id,police_serialno, police_name,station_id,station_name,date';

  vemail_body :=     'Hi, '
                        || crlf || crlf
                        || 'Please find the attached ' 
                        || vfilename
                        || ' file.'
                        || crlf || crlf
                        || 'DO NOT REPLY TO THIS EMAIL. Any questions, contact Scott Henderson from AFC. Email: shenderson@mbta.com'
                        || crlf || crlf
                        || 'Thanks!!';

  vconn := utl_smtp.open_connection('131.108.47.242', 25); --131.108.47.242  smtp.mbta.com
  utl_smtp.helo(vconn, '131.108.47.242');
  
  utl_smtp.mail(vconn, 'shenderson@mbta.com');
  
  utl_smtp.rcpt(vconn, '<kpabba@mbta.com>');
  utl_smtp.rcpt(vconn, '<pmacmillan@MBTA.com>');
  utl_smtp.rcpt(vconn, '<shenderson@mbta.com>');
  utl_smtp.rcpt(vconn, '<rcreedon@mbta.com>');
  utl_smtp.rcpt(vconn, '<jwiesman@mbta.com>');
  
  utl_smtp.open_data(vconn);
  sp_send_header_mbta('From', 'no-reply@MBTA.com');
  sp_send_header_mbta('To', 'pmacmillan@MBTA.com');
  sp_send_header_mbta('Cc', 'shenderson@mbta.com');
  sp_send_header_mbta('Cc', 'rcreedon@mbta.com');
  sp_send_header_mbta('Cc', 'jwiesman@mbta.com');
  sp_send_header_mbta('Subject',  vfilename || ' attached.');
  sp_send_header_mbta('Content-Transfer-Enc.zoding', 'binary');
  sp_send_header_mbta('Content-Type','multipart/mixed; boundary="_----------=_112068030119160"');
  sp_send_header_mbta('MIME-Version', '1.0');
  
  --utl_smtp.write_data(vconn, 'TO:'||'kranthi.pabba@gmail.com' || utl_tcp.crlf);

  utl_smtp.write_data(vconn, utl_tcp.crlf || 'This is a multi-part message in MIME format.');
  utl_smtp.write_data(vconn, utl_tcp.crlf);
  utl_smtp.write_data(vconn, utl_tcp.crlf || '--_----------=_112068030119160');
  utl_smtp.write_data(vconn, utl_tcp.crlf || 'Content-Disposition: inline');
  utl_smtp.write_data(vconn, utl_tcp.crlf ||'Content-Transfer-Encoding: binary');
  utl_smtp.write_data(vconn, utl_tcp.crlf || 'Content-Type: text/plain');
  utl_smtp.write_data(vconn, utl_tcp.crlf);
  utl_smtp.write_data(vconn, utl_tcp.crlf ||vemail_body);
  
  utl_smtp.write_data(vconn, utl_tcp.crlf || '--_----------=_112068030119160');
  utl_smtp.write_data(vconn, utl_tcp.crlf ||'Content-Disposition: inline; filename='|| '"' || vfilename || '"' );   --"test.csv"'
  utl_smtp.write_data(vconn, utl_tcp.crlf ||'Content-Transfer-Encoding: binary');
  utl_smtp.write_data(vconn, utl_tcp.crlf ||'Content-Type: text/csv; name='|| '"' || vfilename || '"' );  --"test.csv"'
  utl_smtp.write_data(vconn, utl_tcp.crlf);
  utl_smtp.write_data(vconn, utl_tcp.crlf ||vcol_header);
  
  for rec in (select number1		
  	||','||number2		
  	||','||data1		
    ||','||data2		
  	||','||data3		
    ||','||to_char(datetime1,'YYYY-MM-DD HH24:MI:SS')  data
  from mbta_tempresult 
  where queryid = vqueryid
  order by number1, number2, data1, data2, data3, datetime1
              )
  loop
  utl_smtp.write_data(vconn, utl_tcp.crlf ||rec.data);
  end loop;
  
  utl_smtp.close_data(vconn);
  utl_smtp.quit(vconn);
  
  exception
      when utl_smtp.transient_error or utl_smtp.permanent_error then
        begin
          utl_smtp.close_data(vconn);
          utl_smtp.quit(vconn);
          raise_application_error(-20001,  substr(sqlerrm, 1, 2048-20));           
           exception
               when utl_smtp.transient_error or utl_smtp.permanent_error
               then
                  null; -- WHEN THE SMTP SERVER IS DOWN OR UNAVAILABLE, WE DON'T HAVE
                         -- A CONNECTION TO THE SERVER. THE QUIT CALL WILL RAISE AN
                         -- EXCEPTION THAT WE CAN IGNORE AND THIS EXCEPTION IS DOING THAT.
                  raise_application_error(-20002,  substr(sqlerrm, 1, 2048-20));                           
        end;
      when others
        then
          utl_smtp.close_data(vconn);
           utl_smtp.quit(vconn);
           raise_application_error(-20003,  substr(sqlerrm, 1, 2048-20));    
          
  end;
/
