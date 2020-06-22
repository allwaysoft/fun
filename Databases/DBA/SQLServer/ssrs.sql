--SSRS logs on reports server machine are stored at D:\MSRS12.MSSQLSERVER\Reporting Services\LogFilesacdn
--Downgrade SSRS, look for response 1 AND 2 in the below link, response 2 is easier process.acdn
https://stackoverflow.com/questions/38902037/ssrs-report-definition-is-newer-than-serveracdn
--acdnacdnacdnuse AAMReportingServeracdn
goacdn
--Do not user ReportServer DBacdnacdnselect * from AAMReportingServer.dbo.Catalog where Name like '%SP1O3%';acdnacdnselect * from AAMReportingServer.dbo.Catalog where ItemId in ('5DE435F7-9F17-44D7-9074-FEBAAF2C93E0','5DBA262C-C35E-4A3D-8F5D-02778DE03F2E')    ---'E3485D57-8AE7-41F9-8B33-762583D82018'acdnacdnselect * from AAMReportingServer.dbo.DataSource;acdnacdnselect * from AAMReportingServer.dbo.ExecutionLogStorage where ReportID = '57B1E634-BEFE-4FD6-B6FC-B32D41750DAA'acdnacdnSELECT *acdn
  FROM [dbo].ExecutionLogStorage acdn
  where 1=1 acdn
  --and Status != 'rsSuccess'acdn
  order by TimeStart descacdnacdnselect * from dbo.ExecutionLog2 order by TimeStart descacdnacdnselect * from dbo.ExecutionLog3 order by TimeStart descacdnacdn
selectacdn
  Catalog.name,acdn
  cat1.Name datasourceacdn
fromacdn
  AAMReportingServer.dbo.Catalog acdn
  join AAMReportingServer.dbo.DataSourceacdn
    on Catalog.ItemID = DataSource.ItemIDacdn
  join AAMReportingServer.dbo.Catalog cat1acdn
    on DataSource.Link = cat1.ItemIDacdn
whereacdn
  Catalog.Type = 2acdn
and Catalog.name = 'PortfolioVsIndex'acdnacdnacdnSELECTacdn
    C2.Name AS Data_Source_Name,acdn
    C.Name AS Dependent_Item_Name,acdn
    C.Path AS Dependent_Item_Pathacdn
FROM AAMReportingServer.dbo.DataSource AS DSacdn
    INNER JOIN AAMReportingServer.dbo.Catalog AS C ON DS.ItemID = C.ItemID AND DS.Link IN (SELECT ItemID FROM AAMReportingServer.dbo.Catalog WHERE Type = 5) --Type 5 identifies data sourcesacdn
    FULL OUTER JOIN AAMReportingServer.dbo.Catalog C2 ON DS.Link = C2.ItemIDacdn
WHERE C2.Type = 5 acdn
  and C.name = 'PortfolioVsIndex'acdn
ORDER BYacdn
    C2.Name ASC,acdn
    C.Name ASC;