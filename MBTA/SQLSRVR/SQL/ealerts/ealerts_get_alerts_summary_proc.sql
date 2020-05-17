USE [thetweb]
GO
/****** Object:  StoredProcedure [dbo].[eAlerts_get_alerts_Summary]    Script Date: 02/01/2011 12:02:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================


CREATE PROCEDURE [dbo].[eAlerts_get_alerts_Summary]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

select mode
     , route
     , alert_count
     , advisory_count
     , snow_route 
from servicealerts_summary
order by mode
       , case when isnumeric(route) = 1 then route 
           else 999999999 
         end
END