USE [thetweb]
GO
/****** Object:  Table [dbo].[ServiceAlerts_archive]    Script Date: 01/27/2011 15:22:43 ******/


select count(1) as servicealerts_before_cnt from servicealerts

select count(1) as servicealerts_archive_before_cnt from servicealerts_archive

insert into servicealerts_archive
select [ServiceAlertID]
      ,[Mode]
      ,[Route]
      ,[Delay]
      ,[Priority]
      ,[TimeOfDelay]
      ,[DelayTime]
      ,[DelayCategory]
      ,[DelayReason]
      ,[MessagePublic]
      ,[MessagePrivate]
      ,[IsClosed]
      ,[DateExpired]
      ,[DateClosed]
      ,[DateCreated]
      ,[TimeCreated]
      ,[DateModified]
      ,getdate() DateArchived
from servicealerts    
where (isnull(delay,'abc') <> 'Advisory' and isnull(isclosed,1) <> 0) 
   or (isnull(delay,'Advisory') = 'Advisory' and isnull(dateexpired,getdate()-1) <= getdate())


delete from servicealerts 
where (isnull(delay,'abc') <> 'Advisory' and isnull(isclosed,1) <> 0) 
   or (isnull(delay,'Advisory') = 'Advisory' and isnull(dateexpired,getdate()-1) <= getdate())


select count(1) as servicealerts_archive_after_cnt from servicealerts_archive

select count(1) as servicealerts_after_cnt from servicealerts


/*
select count(1) from servicealerts
where (isnull(delay,'abc') <> 'Advisory' and isnull(isclosed,1) <> 0) 
   or (isnull(delay,'Advisory') = 'Advisory' and isnull(dateexpired,getdate()-1) <= getdate())


select count(1) from servicealerts
where isclosed = 0 or (delay = 'Advisory' and dateexpired > getdate())

select count(1) from servicealerts
*/