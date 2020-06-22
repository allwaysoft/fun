USE [thetweb]
GO
/****** Object:  StoredProcedure [dbo].[eAlerts_ProcessAlert_new]    Script Date: 02/01/2011 12:02:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[eAlerts_ProcessAlert_new]
	-- Add the parameters for the stored procedure here
		@Alerts_servicealertid nvarchar(5),
		@Alerts_mode nvarchar(20),
		@Alerts_route nvarchar(400),
		@Alerts_delay nvarchar(20),
		@Alerts_priority nvarchar(20),
		@Alerts_timeofdelay nvarchar(100),
		@Alerts_delaytime nvarchar(20),
		@Alerts_delaycategory nvarchar(50),
		@Alerts_delayreason nvarchar(50),
		@Alerts_isclosed nvarchar(2) = null,
		@Alerts_messagepublic nvarchar(3000) = null,
		@Alerts_expiredate datetime = null,
		@Alerts_dateclosed datetime = null,
		@Alerts_datecreated datetime = null,
		@Alerts_timecreated datetime = null,
		@Alerts_talertid nvarchar(50),
		@Alerts_originalid nvarchar(50) = null,
		@Alerts_alerttype nvarchar(2) = null,
		@Alerts_lineelevid nvarchar(20) = null,
		@Alerts_isAdvisory nvarchar(20) = null
AS

BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @IsClosed int, @FinalAlertID nvarchar(50)
	
-----------------------
IF @alerts_isclosed = 'N'
  SET @isclosed = 0
ELSE
  SET @isclosed = 1
-----------------------

------------------------------ Begin Use the the AlertID if already exists in table, else use new
IF @Alerts_mode in ('Elevator','Escalator', 'HP') 
  BEGIN
		-- For Elevator, Esclator, 'HP' ServiceAlertid can not be used in the where 
        -- condition below as everytime an alert or advisory is modified on 
		-- existing alerts, a new ServiceAlertid is sent to the database.
    IF EXISTS (SELECT ServiceAlertID 
                 FROM ServiceAlerts 
               WHERE  Route=@Alerts_route 
               AND ((Delay = 'Advisory' AND dateExpired > getdate()) 
                     OR (Delay <> 'Advisory'AND isclosed = 0)
                   )
              ) 

      SELECT @FinalAlertID = ServiceAlertID 
        FROM servicealerts 
       WHERE Route=@Alerts_route 
         AND DELAY = @Alerts_delay

    ELSE

      SET @FinalAlertID =  @Alerts_talertid

  END

ELSE IF (@Alerts_mode in ('Subway','Bus', 'Boat', 'Commuter Rail', 'Silver Line') 
         AND EXISTS (SELECT ServiceAlertID 
                       FROM ServiceAlerts 
                      WHERE ServiceAlertID=case when @Alerts_originalid = 0 then @Alerts_talertid else @Alerts_originalid end
                        AND Route=@Alerts_route
          -- In the where condition above, we use both @Alerts_originalid and @Alerts_talertid with in a CASE.
          -- We can't just go with the @Alerts_originalid because when an alert is created this procedure might 
          -- be called more than once(since multiple XML's are generated for an alert) and to eliminate duplicates 
          -- in that situtaion we have to go with @Alerts_originalid
                    )
        )

       SET @FinalAlertID = @Alerts_originalid 

     ELSE

       SET @FinalAlertID = @Alerts_talertid
------------------------------ End Use the the AlertID if already exists in table, else use new

-----------------------------------------Begin update or insert servicealerts table
IF (@Alerts_mode in ('Elevator','Escalator', 'HP') 
    AND EXISTS (SELECT ServiceAlertID 
                  FROM ServiceAlerts 
                 WHERE  Route=@Alerts_route 
				   AND ((Delay = 'Advisory' AND dateExpired > getdate()) 
                         OR (Delay <> 'Advisory'AND isclosed = 0)
                       )
               ) 
   )
   OR
   (@Alerts_mode in ('Subway','Bus', 'Boat', 'Commuter Rail', 'Silver Line') 
    AND EXISTS (SELECT ServiceAlertID 
                  FROM ServiceAlerts 
                 WHERE ServiceAlertID=case when @Alerts_originalid = 0 then @Alerts_talertid else @Alerts_originalid end
                   AND Route=@Alerts_route
               )
   )
  BEGIN
				update ServiceAlerts Set
					Mode = @Alerts_mode,
					Route = @Alerts_route,
					[Delay] = @Alerts_delay,
					Priority =@Alerts_priority ,
					TimeOfDelay = @Alerts_timeofdelay,
					DelayTime = @Alerts_delaytime,
					DelayCategory = @Alerts_delaycategory,
					DelayReason = @Alerts_delayreason,
					MessagePublic = @Alerts_messagepublic,
					MessagePrivate = '',
					IsClosed = @IsClosed,
					DateExpired = @Alerts_expiredate,
					DateClosed = @Alerts_dateclosed,
					DateCreated = @Alerts_datecreated,
					TimeCreated = @Alerts_timecreated,
					DateModified = GetDate()
				where ServiceAlertID = @FinalAlertID 
                  and Route = @Alerts_route
                  and delay = @Alerts_delay
  END  
ELSE 
  BEGIN
				insert into ServiceAlerts (
				ServiceAlertID,
				Mode,
				Route,
				[Delay],
				Priority,
				TimeOfDelay,
				DelayTime,
				DelayCategory,
				DelayReason,
				MessagePublic,
				MessagePrivate,
				IsClosed,
				DateExpired,
				DateClosed,
				DateCreated,
				TimeCreated,
				DateModified)
			values (
				@FinalAlertID,
				@Alerts_mode,
				@Alerts_route,
				@Alerts_delay,
				@Alerts_priority,
				@Alerts_timeofdelay,
				@Alerts_delaytime,
				@Alerts_delaycategory,
				@Alerts_delayreason,
				@Alerts_messagepublic,
				'',
				@IsClosed,
				@Alerts_expiredate,
				@Alerts_dateclosed,
				@Alerts_datecreated,
				@Alerts_timecreated,
				GetDate())

  END
-------------------------------------------End update or insert servicealerts table

--------Begin Procedure Call to Populate the servicealerts_summary Table used in populating Alerts in the MBTA Main Page

EXECUTE ealerts_insert_alerts_summary

--------End Procedure Call to Populate the servicealerts_summary Table used in populating Alerts in the MBTA Main Page


END