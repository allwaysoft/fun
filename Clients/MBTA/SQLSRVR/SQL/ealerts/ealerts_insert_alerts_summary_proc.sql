USE [thetweb]
GO
/****** Object:  StoredProcedure [dbo].[ealerts_insert_alerts_summary]    Script Date: 02/01/2011 12:02:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ealerts_insert_alerts_summary]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here


DELETE FROM servicealerts_summary

INSERT INTO servicealerts_summary
select mode
     , case when mode in ('Elevator', 'Escalator', 'HP') then mode 
         else case when mode = 'Bus' then substring(route, 0, charindex(' ', route))
                else route 
              end 
       end route
     , sum(case when delay = 'Advisory' then 0
             else 1 
           end
          ) alr_cnt
     , sum(case when delay = 'Advisory' then 1
             else 0 
           end
          ) adv_cnt
     , case when charindex('SNOW ROUTE', upper(messagepublic)) <> 0 then 'Y'
         else 'N' 
       end snow_route
from servicealerts
where mode in ('Subway', 'Boat', 'Bus', 'Commuter Rail', 'Elevator', 'Escalator', 'HP')
  and (isclosed = 0 or (delay = 'Advisory' and dateexpired > getdate()))
group by mode
       , case when mode in ('Elevator', 'Escalator','HP') then mode 
           else case when mode = 'Bus' then substring(route, 0, charindex(' ', route))
                  else route 
                end 
         end
       , case when charindex('SNOW ROUTE', upper(messagepublic)) <> 0 then 'Y'
           else 'N' 
         end
UNION ALL
select SL.mode
     , SL.mode
     , sum(case when SL.delay = 'Advisory' then 0
             else 1 
           end
          ) alr_cnt
     , sum(case when SL.delay = 'Advisory' then 1
             else 0 
           end
          ) adv_cnt
     , null 
from
(
select mode, delay, servicealertid     
from servicealerts
where mode = 'Silver Line'
  and (isclosed = 0 or (delay = 'Advisory' and dateexpired > getdate()))
group by mode, delay, servicealertid
) SL
group by SL.mode
END