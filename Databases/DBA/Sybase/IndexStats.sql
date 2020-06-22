/*
There are some gotcha's in this process. Please look at the below JIRA story for more information on this.https://acadian-asset.atlassian.net/browse/SOPS-743
*/
SELECT
    TableId, IndexId, TableName, IndexName,
    LEFT(LockScheme_IndexType, CHARINDEX('_',LockScheme_IndexType) - 1),
    RIGHT(LockScheme_IndexType, LEN(LockScheme_IndexType) - CHARINDEX('_',LockScheme_IndexType)),
    DPCR, IPCR, SPUT, LGIO, FWDR, DELR, isDefragCandidate
FROM (
select * from AAM_metadata.dbo.dbaDefragHistory where TableName = 'pt_mrktomkt' order by DefragDatesp_showoptstats 'hinet.dbo.pt_mrktomkt'
    SELECT
        o.id AS TableId,
        i.indid AS IndexId,
        o.name AS TableName,
        i.name AS IndexName,
        CASE
            WHEN o.sysstat2 & 16384 = 16384 OR o.sysstat2 & 32768 = 32768 THEN --16384 Table uses data pages locking scheme. 32768 Table uses datarows locking scheme. pt_mrktomkt table qualifies here
                CASE
                    WHEN i.status2 & 512 = 512 THEN --512 Table is a data-only-locked table with a clustered index
                        'DataOnly_Placement'
                    WHEN i.indid = 0 THEN  --0 = if a table. 1 = if a clustered index on an allpages-locked table. >1 = if a nonclustered index or a clustered index on a data-only-locked table. 255 = if text, image, text chain, or Java off-row structure (large object�or LOB�structure).
                        'DataOnly_Heap'
                    ELSE 
                        'DataOnly_NonClustered'
                END
            ELSE
                CASE
                    WHEN i.status & 16 = 16 THEN 
                        'AllPages_Clustered'
                    WHEN i.indid = 0 THEN
                        'AllPages_Heap'
                    ELSE
                        'AllPages_NonClustered'
                END
        END AS LockScheme_IndexType,
        DERIVED_STAT(o.id,i.indid,'dpcr') AS DPCR,
        DERIVED_STAT(o.id,i.indid,'ipcr') AS IPCR,
        DERIVED_STAT(o.id,i.indid,'sput') AS SPUT,
        DERIVED_STAT(o.id,i.indid,'lgio') AS LGIO,
        CASE WHEN ts.rowcnt = 0 THEN 0 ELSE ts.forwrowcnt/ts.rowcnt END AS FWDR,
        CASE WHEN ts.rowcnt = 0 THEN 0 ELSE ts.delrowcnt/ts.rowcnt END AS DELR,
o.sysstat2,
o.sysstat2 & 16384 a,
o.sysstat2 & 32768 b,
i.status2 & 512 c,
--i.status & 16,
        CASE
            WHEN o.sysstat2 & 16384 = 16384 OR o.sysstat2 & 32768 = 32768 THEN --For Data Only Locking or Data Row Locking tables
                CASE
                    WHEN i.status2 & 512 = 512 OR i.indid = 0 THEN --For clustered index or table
                        CASE
                            WHEN
                                DERIVED_STAT(o.id,i.indid,'dpcr') <= 0.3 OR
                                DERIVED_STAT(o.id,i.indid,'sput') <= 0.3 OR
                                DERIVED_STAT(o.id,i.indid,'lgio') <= 0.3 OR
                                CASE WHEN ts.rowcnt = 0 THEN 0 ELSE ts.forwrowcnt/ts.rowcnt END >= 0.25 OR
                                CASE WHEN ts.rowcnt = 0 THEN 0 ELSE ts.delrowcnt/ts.rowcnt END >= 0.25
                            THEN 1
                            ELSE 0
                        END
                    ELSE --For NonClustered Indexes
                        CASE 
                            WHEN
                                DERIVED_STAT(o.id,i.indid,'ipcr') <= 0.3 OR
                                DERIVED_STAT(o.id,i.indid,'sput') <= 0.3 OR
                                DERIVED_STAT(o.id,i.indid,'lgio') <= 0.3
                            THEN 1
                            ELSE 0
                        END
                END
            ELSE
                CASE
                    WHEN i.status & 16 = 16 OR i.indid = 0 THEN 
                        CASE
                            WHEN
                                DERIVED_STAT(o.id,i.indid,'dpcr') <= 0.3 OR
                                DERIVED_STAT(o.id,i.indid,'sput') <= 0.3 OR
                                DERIVED_STAT(o.id,i.indid,'lgio') <= 0.3
                            THEN 1
                            ELSE 0
                        END
                    ELSE
                        CASE
                            WHEN
                                DERIVED_STAT(o.id,i.indid,'ipcr') <= 0.3 OR
                                DERIVED_STAT(o.id,i.indid,'sput') <= 0.3 OR
                                DERIVED_STAT(o.id,i.indid,'lgio') <= 0.3
                            THEN 1
                            ELSE 0
                        END
                END
        END AS isDefragCandidate
    FROM sysobjects o
    INNER JOIN sysindexes i ON i.id = o.id
    INNER JOIN systabstats ts ON ts.id = o.id AND ts.indid = i.indid
    INNER JOIN (
        SELECT id, rowcnt, pagecnt
        FROM systabstats
        WHERE indid IN (0,1)
    ) rp ON rp.id = o.id
    WHERE
        o.name NOT LIKE 'sys%' AND
        rp.rowcnt > 0 AND
        rp.pagecnt > 1000
and i.id = 27147142) a
--WHERE isDefragCandidate = 1
where TableId = 27147142
ORDER BY TableName, IndexName/*
** Get the Placement Index for any DataOnly Heap where the Placement Index is not already in the table
** and it's not a candidate because of forwarded/deleted rows
*/
/*
INSERT INTO #DefragCandidates
SELECT
    i.id, i.indid, dc.TableName, i.name, dc.LockScheme, 'Placement',
    dc.DPCR, dc.IPCR, dc.SPUT, dc.LGIO, dc.FWDR, dc.DELR, ''
FROM #DefragCandidates dc
INNER JOIN sysindexes i ON i.id = OBJECT_ID(dc.TableName)
WHERE
    i.status2 & 512 = 512 AND
    dc.IndexType = 'Heap' AND
    (dc.DPCR <= 0.3 OR dc.SPUT <= 0.3 OR dc.LGIO <= 0.3) AND
    i.name NOT IN (
        SELECT IndexName FROM #DefragCandidates WHERE IndexType = 'Placement'
    )
*/select o.sysstat2 & 16384, o.sysstat2 & 32768 from sysobjects o where name = 'pt_mrktomkt'
select status2 & 512, * from sysindexes where name = 'pt_mrktomkt'
    SELECT
        USER_NAME(o.uid),
        o.name,
        i.name,
        i.indid,
        CASE WHEN s.name = 'default' THEN '"' + s.name + '"' ELSE s.name END,
        CASE WHEN i.status & 16 = 16 THEN i.keycnt ELSE i.keycnt - 1 END,
/*
        CASE
            WHEN @lockType = 0 THEN
                CASE WHEN i.status & 16 = 16 THEN 1 ELSE 0 END
            ELSE
                CASE WHEN i.status2 & 512 = 512 THEN 1 ELSE 0 END
        END,
*/
        CASE WHEN i.status & 2048 = 2048 THEN 1 ELSE 0 END,
        CASE WHEN i.status & 2 = 2 THEN 1 ELSE 0 END,
        CASE WHEN i.status & 1 = 1 THEN 1 ELSE 0 END,
        CASE WHEN i.status & 4 = 4 THEN 1 ELSE 0 END,
        CASE WHEN i.status & 64 = 64 THEN 1 ELSE 0 END,
        i.maxrowsperpage,
        i.fill_factor,
        i.res_page_gap,
        ''      
    FROM sysobjects o
    INNER JOIN sysindexes i ON i.id = o.id
    INNER JOIN syssegments s ON i.segment = s.segment
    WHERE
        o.type = 'U' AND
        o.name = 'pt_mrktomkt' AND
        indid BETWEEN 1 AND 254;