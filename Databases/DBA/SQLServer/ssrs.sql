--SSRS logs on reports server machine are stored at D:\MSRS12.MSSQLSERVER\Reporting Services\LogFiles
--Downgrade SSRS, look for response 1 AND 2 in the below link, response 2 is easier process.
https://stackoverflow.com/questions/38902037/ssrs-report-definition-is-newer-than-server
--
use AAMReportingServer
go
--Do not use ReportServer DB
select * from AAMReportingServer.dbo.Catalog where Name like '%SP1O3%';
select * from AAMReportingServer.dbo.Catalog where ItemId in ('5DE435F7-9F17-44D7-9074-FEBAAF2C93E0','5DBA262C-C35E-4A3D-8F5D-02778DE03F2E')    ---'E3485D57-8AE7-41F9-8B33-762583D82018'
select * from AAMReportingServer.dbo.DataSource;
select * from AAMReportingServer.dbo.ExecutionLogStorage where ReportID = '57B1E634-BEFE-4FD6-B6FC-B32D41750DAA'
SELECT * 
  FROM [dbo].ExecutionLogStorage 
  where 1=1 
  --and Status != 'rsSuccess'
  order by TimeStart descselect * from dbo.ExecutionLog2 order by TimeStart desc
  select * from dbo.ExecutionLog3 order by TimeStart desc
select
  Catalog.name,
  cat1.Name datasource
from
  AAMReportingServer.dbo.Catalog 
  join AAMReportingServer.dbo.DataSource
    on Catalog.ItemID = DataSource.ItemID
  join AAMReportingServer.dbo.Catalog cat1
    on DataSource.Link = cat1.ItemID
where
  Catalog.Type = 2
and Catalog.name = 'PortfolioVsIndex'SELECT
    C2.Name AS Data_Source_Name,
    C.Name AS Dependent_Item_Name,
    C.Path AS Dependent_Item_Path
FROM AAMReportingServer.dbo.DataSource AS DS
    INNER JOIN AAMReportingServer.dbo.Catalog AS C ON DS.ItemID = C.ItemID AND DS.Link IN (SELECT ItemID FROM AAMReportingServer.dbo.Catalog WHERE Type = 5) --Type 5 identifies data sources
    FULL OUTER JOIN AAMReportingServer.dbo.Catalog C2 ON DS.Link = C2.ItemID
WHERE C2.Type = 5 
  and C.name = 'PortfolioVsIndex'
ORDER BY
    C2.Name ASC,
    C.Name ASC;