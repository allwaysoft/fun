use Loggo
SELECT * FROM dbo.etlPackage where Name = 'ETL_CUST_HoldingFileCiti'
select * from Log.dbo.etlPackage where Name = 'ETL_TRADING_ExportTomsExecutedFXForwardTradesToSSC';
select * from Log.dbo.VWetlPackageExecutionLog;
select * from Log.dbo.etlPackageExecutionQueue;
select top 100 * from Log.dbo.etlPackageLog where PackageName = 'ETL_TRADING_ExportTomsExecutedFXForwardTradesToSSC' order by StartTime desc;
select top 100 * from Log.dbo.etlDataFlowLog order by EndTime desc;
select top 100 * from Log.dbo.etlDataFlowErrorLog