https://www.mssqltips.com/sqlservertip/1185/minimally-logging-bulk-load-inserts-into-sql-server/ --Article slightly inaccurate, read the 1st comment in the article, that explains the issue with the article
https://www.sqlshack.com/techniques-to-bulk-copy-import-and-export-in-sql-server/
https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2008/dd537533(v=sql.100)?redirectedfrom=MSDN --Move 1TB data in 30 minutes
--Bulk loading data
    --If log shipping is enabled, bulk insert operations could still benifit from bulk logging mode but the point in time recovery is lost for the duration of the bulk insert operation
    --If there is a possibility to load data into a new database and keep them there in a sql server instance. Always doing that would be better because just keep that db in simple revovery model, do the load and then setup logshipping on it if required
    --Try and insert the data sorted into table with a clustered index. Do not have any other indexes before the data load, those should be created after the load for better performance
    --Always load data concurrently into multiple table partitions which are in multiple disk volumes for the best performanceDB in Bluk logging mode
Clustered INDEX
Bluk insert into different partitions
Lock escalation set to partition instead of table
All partitions point to the same file group which is going to different drive volumes but behind the senes they are all on same san?To no have tlog issues, one other option that Frank brought up was to have the new tables in the new DB and keep in simple mode and once load is done, setup logg shipping with full recover model.
Access the new tables with views from different database, I didnt like idea but just wanted to present.
1. Stop the snaps in production
2. 