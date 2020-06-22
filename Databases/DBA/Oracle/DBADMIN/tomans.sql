
SELECT /*+ parallel(sd 4) */          -----25066693 records
COUNT(1) from salesdetail sd
WHERE   sd.CreaDate            >= to_date('2010-01-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND       sd.CreaDate            <= to_date('2010-02-01-02-59-59','YYYY-MM-DD-HH24-MI-SS')
AND       sd.PartitioningDate    >= to_date('2010-01-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND       sd.PartitioningDate    <  to_date('2010-03-01-00-00-00','YYYY-MM-DD-HH24-MI-SS')
AND    sd.ArticleNo                >     100000
AND    sd.CorrectionFlag            =     0
AND    sd.RealStatisticArticle        =     0
AND    sd.TempBooking                =     0
AND    sd.ArticleNo                <>     607900100



SELECT /*+ parallel(sd 4)    INDEX (sd    XIE1SalesDetail)*/     --11103 records
COUNT(1) from salesdetail sd
WHERE   sd.CreaDate            >= to_date('2010-01-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND       sd.CreaDate            <= to_date('2010-02-01-02-59-59','YYYY-MM-DD-HH24-MI-SS')
AND       sd.PartitioningDate    >= to_date('2010-01-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND       sd.PartitioningDate    <  to_date('2010-03-01-00-00-00','YYYY-MM-DD-HH24-MI-SS')
AND    sd.ArticleNo                =     607900100


