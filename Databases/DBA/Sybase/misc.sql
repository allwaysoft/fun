->Sybase server log location: 
    $SYBASE/$SYBASE_ASE/install/BOSDBHINET01.log --Use this for Hinet server logs
    $SYBASE/$SYBASE_ASE/install/BOSDBHINET01_BACK.log --Use this for Hinet backup server logs
    /opt/sybase/db/sybase/ASE-15_0/install
    
->Scripts location (Acadian Specific)
    /opt/sybase/backup/scriptsRestart backup SERVER
    /opt/sybase/db/sybase/ASE-15_0/BOSDBHINET01.cfg -M/opt/sybase/db/sybase/ASE-15_0    
sp_version
go
sp_helpindex pt_mrktomkt --xc_mrktomkt --x2_mrktomkt --idx_acid_trade_date

select object_name(i.id) AS OBJECTNAME, i.name AS INDEXNAME
,CASE WHEN convert(varchar(8),lockscheme(i.id)) = 'allpages' THEN 'APL' 
      WHEN convert(varchar(8),lockscheme(i.id)) = 'datapages' THEN 'DPG' 
      ELSE 'DRW' 
 END AS 'SCHEME'
,CASE WHEN i.status2 & 512 = 512 OR i.status & 16 = 16 THEN 'CLI' WHEN i.indid = 0THEN 'TBL' ELSE 'NCL' END AS 'IDXTYPE'
,'DPCR' = convert(decimal(6,2),isnull(derived_stat(i.id,i.indid,'dpcr'),0.00))
,'DRCR' = convert(decimal(6,2),isnull(derived_stat(i.id,i.indid,'drcr'),0.00))
,'SPUT' = convert(decimal(6,2),isnull(derived_stat(i.id,i.indid,'sput'),0.00))
,'LGIO' = convert(decimal(6,2),isnull(derived_stat(i.id,i.indid,'lgio'),0.00))
,'IPCR' = convert(decimal(6,2),isnull(derived_stat(i.id,i.indid,'ipcr'),0.00))
,'FROW' = ltrim(convert(varchar(8),str(round(convert(double precision,t.forwrowcnt),16),8,2)))
,'DROW' = ltrim(convert(varchar(8),str(round(convert(double precision,t.delrowcnt),16),8,2)))
,'NROW' = ltrim(convert(varchar(8),str(round(convert(double precision,t.rowcnt),16),8,2)))
,'SPACEKB' = convert(numeric(15, 2),(reserved_pages(db_id(),i.id, i.indid))*2)
from sysindexes i, sysobjects o,systabstats t
where o.id=i.id and o.type = 'U' and o.id=t.id and i.id=t.id and i.indid=t.indid
and i.name = 'idx_acid_trade_date'