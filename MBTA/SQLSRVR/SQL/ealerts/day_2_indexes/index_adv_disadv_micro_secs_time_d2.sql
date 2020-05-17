
update statistics servicealerts
go
------no indexes
------
exec eAlerts_getAdvisoryDetails @mode='cr', @route='', @Detail = '1' --1148
go
exec eAlerts_getAdvisoryDetails @mode='subway', @route='Silver Line', @Detail ='' --1107
go
exec eAlerts_getAdvisoryDetails @mode='Elevator', @route='Escalator', @Detail ='' --1205
go
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Lift', @Detail ='' --1128
go
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Boat', @Detail ='' --1177
go

exec eAlerts_getAlertDetails @mode='cr', @route='', @Detail = '1' --1248
go
exec eAlerts_getAlertDetails @mode='subway', @route='Silver Line', @Detail ='' --9354
go
exec eAlerts_getAlertDetails @mode='Elevator', @route='Escalator', @Detail ='' --1118
go
exec eAlerts_getAlertDetails @mode='', @Route = 'Lift', @Detail ='' --1367
go
exec eAlerts_getAlertDetails @mode='', @Route = 'Boat', @Detail ='' --9010
-----
--no indexes


CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Route ON [thetweb].[dbo].[ServiceAlerts] ( [Route] ) ;
go
CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Mode ON [thetweb].[dbo].[ServiceAlerts] ( [Mode] ) INCLUDE ([ServiceAlertID], [Delay], [IsClosed], [DateExpired]);
go
update statistics servicealerts
go


---- Below indexes 1
----
--CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Route ON [thetweb].[dbo].[ServiceAlerts] ( [Route] ) ;
--CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Mode ON [thetweb].[dbo].[ServiceAlerts] ( [Mode] ) INCLUDE ([ServiceAlertID], [Delay], [IsClosed], [DateExpired]);
-----
exec eAlerts_getAdvisoryDetails @mode='cr', @route='', @Detail = '1' --5424
go
exec eAlerts_getAdvisoryDetails @mode='subway', @route='Silver Line', @Detail ='' --4692
go
exec eAlerts_getAdvisoryDetails @mode='Elevator', @route='Escalator', @Detail ='' --4548
go
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Lift', @Detail ='' --100
go
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Boat', @Detail ='' --4517
go

exec eAlerts_getAlertDetails @mode='cr', @route='', @Detail = '1' --5328
go
exec eAlerts_getAlertDetails @mode='subway', @route='Silver Line', @Detail ='' --8063
go
exec eAlerts_getAlertDetails @mode='Elevator', @route='Escalator', @Detail ='' --4933
go
exec eAlerts_getAlertDetails @mode='', @Route = 'Lift', @Detail ='' --4612
go
exec eAlerts_getAlertDetails @mode='', @Route = 'Boat', @Detail ='' --8218
------------
------------


drop index ix_ServiceAlerts_Mode on servicealerts
go
drop index ix_ServiceAlerts_Route on servicealerts
go
CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Route ON [thetweb].[dbo].[ServiceAlerts] ( [Route] ) ;
go
CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Mode ON [thetweb].[dbo].[ServiceAlerts] ( [Mode] );
go
CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Delay ON [thetweb].[dbo].[ServiceAlerts] ( [Delay] );
go
update statistics servicealerts
go


---- Below indexes 2
----
--CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Route ON [thetweb].[dbo].[ServiceAlerts] ( [Route] ) ;
--CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Mode ON [thetweb].[dbo].[ServiceAlerts] ( [Mode] );
--CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Delay ON [thetweb].[dbo].[ServiceAlerts] ( [Delay] );
-----
exec eAlerts_getAdvisoryDetails @mode='cr', @route='', @Detail = '1' --5405
go
exec eAlerts_getAdvisoryDetails @mode='subway', @route='Silver Line', @Detail ='' --6710
go
exec eAlerts_getAdvisoryDetails @mode='Elevator', @route='Escalator', @Detail ='' --6608
go
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Lift', @Detail ='' --678
go
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Boat', @Detail ='' --6515
go

exec eAlerts_getAlertDetails @mode='cr', @route='', @Detail = '1' --5613
go
exec eAlerts_getAlertDetails @mode='subway', @route='Silver Line', @Detail ='' --9848
go
exec eAlerts_getAlertDetails @mode='Elevator', @route='Escalator', @Detail ='' --5516
go
exec eAlerts_getAlertDetails @mode='', @Route = 'Lift', @Detail ='' --5131
go
exec eAlerts_getAlertDetails @mode='', @Route = 'Boat', @Detail ='' --9271
------------
------------


drop index ix_ServiceAlerts_Route ON [thetweb].[dbo].[ServiceAlerts]
go
drop index ix_ServiceAlerts_Mode ON [thetweb].[dbo].[ServiceAlerts]
go
drop INDEX ix_ServiceAlerts_Delay ON [thetweb].[dbo].[ServiceAlerts]
go
CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Route ON [thetweb].[dbo].[ServiceAlerts] ( [Route] ) ;
go
CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Mode ON [thetweb].[dbo].[ServiceAlerts] ( [Mode] );
go
update statistics servicealerts
go


---- Below indexes 3
----
--CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Route ON [thetweb].[dbo].[ServiceAlerts] ( [Route] ) ;
--CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Mode ON [thetweb].[dbo].[ServiceAlerts] ( [Mode] );
-----
exec eAlerts_getAdvisoryDetails @mode='cr', @route='', @Detail = '1' --5222
go
exec eAlerts_getAdvisoryDetails @mode='subway', @route='Silver Line', @Detail ='' --5394
go
exec eAlerts_getAdvisoryDetails @mode='Elevator', @route='Escalator', @Detail ='' --4778
go
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Lift', @Detail ='' --96
go
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Boat', @Detail ='' --4864
go

exec eAlerts_getAlertDetails @mode='cr', @route='', @Detail = '1' --5298
go
exec eAlerts_getAlertDetails @mode='subway', @route='Silver Line', @Detail ='' --9564
go
exec eAlerts_getAlertDetails @mode='Elevator', @route='Escalator', @Detail ='' --5097
go
exec eAlerts_getAlertDetails @mode='', @Route = 'Lift', @Detail ='' --4820
go
exec eAlerts_getAlertDetails @mode='', @Route = 'Boat', @Detail ='' --10184
------------
------------


drop index ix_ServiceAlerts_Route ON [thetweb].[dbo].[ServiceAlerts]
go
drop INDEX ix_ServiceAlerts_Mode ON [thetweb].[dbo].[ServiceAlerts]
go
CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Route ON [thetweb].[dbo].[ServiceAlerts] ( [Route] ) ;
go
update statistics servicealerts
go


---- Below indexes 4
----
--CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Route ON [thetweb].[dbo].[ServiceAlerts] ( [Route] ) ;
-----
exec eAlerts_getAdvisoryDetails @mode='cr', @route='', @Detail = '1' --5048
go
exec eAlerts_getAdvisoryDetails @mode='subway', @route='Silver Line', @Detail ='' --4672
go
exec eAlerts_getAdvisoryDetails @mode='Elevator', @route='Escalator', @Detail ='' --4649
go
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Lift', @Detail ='' --1087
go
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Boat', @Detail ='' --4627
go

exec eAlerts_getAlertDetails @mode='cr', @route='', @Detail = '1' --5189
go
exec eAlerts_getAlertDetails @mode='subway', @route='Silver Line', @Detail ='' --8921
go
exec eAlerts_getAlertDetails @mode='Elevator', @route='Escalator', @Detail ='' --4985
go
exec eAlerts_getAlertDetails @mode='', @Route = 'Lift', @Detail ='' --4733
go
exec eAlerts_getAlertDetails @mode='', @Route = 'Boat', @Detail ='' --8980
------------
------------


drop INDEX ix_ServiceAlerts_Route ON [thetweb].[dbo].[ServiceAlerts]
go
CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Route ON [thetweb].[dbo].[ServiceAlerts] ( [Route] ) ;
go
CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Mode ON [thetweb].[dbo].[ServiceAlerts] ( [Mode] ) INCLUDE ([Delay], [IsClosed], [DateExpired]);
go
update statistics servicealerts
go


---- Below indexes 5
----
--CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Route ON [thetweb].[dbo].[ServiceAlerts] ( [Route] ) ;
--CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Mode ON [thetweb].[dbo].[ServiceAlerts] ( [Mode] ) INCLUDE ([Delay], [IsClosed], [DateExpired]);
-----
exec eAlerts_getAdvisoryDetails @mode='cr', @route='', @Detail = '1' --5254
go
exec eAlerts_getAdvisoryDetails @mode='subway', @route='Silver Line', @Detail ='' --4544
go
exec eAlerts_getAdvisoryDetails @mode='Elevator', @route='Escalator', @Detail ='' --4588
go
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Lift', @Detail ='' --111
go
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Boat', @Detail ='' --4542
go

exec eAlerts_getAlertDetails @mode='cr', @route='', @Detail = '1' --5549
go
exec eAlerts_getAlertDetails @mode='subway', @route='Silver Line', @Detail ='' --8077
go
exec eAlerts_getAlertDetails @mode='Elevator', @route='Escalator', @Detail ='' --4922
go
exec eAlerts_getAlertDetails @mode='', @Route = 'Lift', @Detail ='' --4611
go
exec eAlerts_getAlertDetails @mode='', @Route = 'Boat', @Detail ='' --8139
------------
------------


drop index ix_ServiceAlerts_Mode on servicealerts
go
drop index ix_ServiceAlerts_Route on servicealerts
go
CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Mode ON [thetweb].[dbo].[ServiceAlerts] ( [Mode] );
go
CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Delay ON [thetweb].[dbo].[ServiceAlerts] ( [Delay] );
go
CREATE NONCLUSTERED INDEX ix_ServiceAlerts_dateexpired ON [thetweb].[dbo].[ServiceAlerts] ( [dateexpired] );
go
update statistics servicealerts
go

---- Below indexes 6
----
--CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Mode ON [thetweb].[dbo].[ServiceAlerts] ( [Mode] );
--CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Delay ON [thetweb].[dbo].[ServiceAlerts] ( [Delay] );
--CREATE NONCLUSTERED INDEX ix_ServiceAlerts_dateexpired ON [thetweb].[dbo].[ServiceAlerts] ( [dateexpired] );
-----
exec eAlerts_getAdvisoryDetails @mode='cr', @route='', @Detail = '1' -- All in 5000 to 6000 micro secs
go
exec eAlerts_getAdvisoryDetails @mode='subway', @route='Silver Line', @Detail ='' --
go
exec eAlerts_getAdvisoryDetails @mode='Elevator', @route='Escalator', @Detail ='' --
go
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Lift', @Detail ='' --
go
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Boat', @Detail ='' --
go

exec eAlerts_getAlertDetails @mode='cr', @route='', @Detail = '1' --
go
exec eAlerts_getAlertDetails @mode='subway', @route='Silver Line', @Detail ='' --
go
exec eAlerts_getAlertDetails @mode='Elevator', @route='Escalator', @Detail ='' --
go
exec eAlerts_getAlertDetails @mode='', @Route = 'Lift', @Detail ='' --
go
exec eAlerts_getAlertDetails @mode='', @Route = 'Boat', @Detail ='' --
------------
------------


drop index ix_ServiceAlerts_Mode on servicealerts
go
drop index ix_ServiceAlerts_Route on servicealerts
go
drop index ix_ServiceAlerts_dateexpired on servicealerts
go
update statistics servicealerts
go

-----
-- After drop all and update Stats
-----
exec eAlerts_getAdvisoryDetails @mode='cr', @route='', @Detail = '1' --1005
go
exec eAlerts_getAdvisoryDetails @mode='subway', @route='Silver Line', @Detail ='' --1203
go
exec eAlerts_getAdvisoryDetails @mode='Elevator', @route='Escalator', @Detail ='' --1342
go
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Lift', @Detail ='' --1007
go
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Boat', @Detail ='' --1098
go

exec eAlerts_getAlertDetails @mode='cr', @route='', @Detail = '1' --1320
go
exec eAlerts_getAlertDetails @mode='subway', @route='Silver Line', @Detail ='' --1236
go
exec eAlerts_getAlertDetails @mode='Elevator', @route='Escalator', @Detail ='' --1053
go
exec eAlerts_getAlertDetails @mode='', @Route = 'Lift', @Detail ='' --1068
go
exec eAlerts_getAlertDetails @mode='', @Route = 'Boat', @Detail ='' --1041
------------
------------
