------no indexes
exec eAlerts_getAdvisoryDetails

@mode='cr', @route='', @Detail = '1' --1769
@mode='subway', @route='Silver Line', @Detail ='' --2056
@mode='Elevator', @route='Escalator', @Detail ='' --2108
@mode='', @Route = 'Lift', @Detail ='' --1680
@mode='', @Route = 'Boat', @Detail ='' --2002

exec eAlerts_getAlertDetails 

@mode='cr', @route='', @Detail = '1' --54444
@mode='subway', @route='Silver Line', @Detail ='' --1977
@mode='Elevator', @route='Escalator', @Detail ='' --2253
@mode='', @Route = 'Lift', @Detail ='' --2010
@mode='', @Route = 'Boat', @Detail ='' --2066

--no indexes

---- Below indexes
----
--CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Route ON [thetweb].[dbo].[ServiceAlerts] ( [Route] ) ;
--CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Mode ON [thetweb].[dbo].[ServiceAlerts] ( [Mode] ) INCLUDE ([ServiceAlertID], [Delay], [IsClosed], [DateExpired]);
-----
exec eAlerts_getAdvisoryDetails @mode='cr', @route='', @Detail = '1' --8295
exec eAlerts_getAdvisoryDetails @mode='subway', @route='Silver Line', @Detail ='' --6911
exec eAlerts_getAdvisoryDetails @mode='Elevator', @route='Escalator', @Detail ='' --6834
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Lift', @Detail ='' --209
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Boat', @Detail ='' --6846

exec eAlerts_getAlertDetails @mode='cr', @route='', @Detail = '1' --16559
exec eAlerts_getAlertDetails @mode='subway', @route='Silver Line', @Detail ='' --10598
exec eAlerts_getAlertDetails @mode='Elevator', @route='Escalator', @Detail ='' --7396
exec eAlerts_getAlertDetails @mode='', @Route = 'Lift', @Detail ='' --6560
exec eAlerts_getAlertDetails @mode='', @Route = 'Boat', @Detail ='' --10610
------------
------------

drop index ix_ServiceAlerts_Mode on servicealerts


---- Below indexes trace2
----
--CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Route ON [thetweb].[dbo].[ServiceAlerts] ( [Route] ) ;
--CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Mode ON [thetweb].[dbo].[ServiceAlerts] ( [Mode] );
--CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Delay ON [thetweb].[dbo].[ServiceAlerts] ( [Delay] );
-----
exec eAlerts_getAdvisoryDetails @mode='cr', @route='', @Detail = '1' --8444
exec eAlerts_getAdvisoryDetails @mode='subway', @route='Silver Line', @Detail ='' --10278
exec eAlerts_getAdvisoryDetails @mode='Elevator', @route='Escalator', @Detail ='' --10166
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Lift', @Detail ='' --1233
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Boat', @Detail ='' --10162

exec eAlerts_getAlertDetails @mode='cr', @route='', @Detail = '1' --9000
exec eAlerts_getAlertDetails @mode='subway', @route='Silver Line', @Detail ='' --13925
exec eAlerts_getAlertDetails @mode='Elevator', @route='Escalator', @Detail ='' --8161
exec eAlerts_getAlertDetails @mode='', @Route = 'Lift', @Detail ='' --7915
exec eAlerts_getAlertDetails @mode='', @Route = 'Boat', @Detail ='' --13180
------------
------------
drop INDEX ix_ServiceAlerts_Delay ON [thetweb].[dbo].[ServiceAlerts]



---- Below indexes trace3
----
--CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Route ON [thetweb].[dbo].[ServiceAlerts] ( [Route] ) ;
--CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Mode ON [thetweb].[dbo].[ServiceAlerts] ( [Mode] );
-----
exec eAlerts_getAdvisoryDetails @mode='cr', @route='', @Detail = '1' --8517
exec eAlerts_getAdvisoryDetails @mode='subway', @route='Silver Line', @Detail ='' --7915
exec eAlerts_getAdvisoryDetails @mode='Elevator', @route='Escalator', @Detail ='' --7212
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Lift', @Detail ='' --198
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Boat', @Detail ='' --7827

exec eAlerts_getAlertDetails @mode='cr', @route='', @Detail = '1' --8549
exec eAlerts_getAlertDetails @mode='subway', @route='Silver Line', @Detail ='' --12863
exec eAlerts_getAlertDetails @mode='Elevator', @route='Escalator', @Detail ='' --7728
exec eAlerts_getAlertDetails @mode='', @Route = 'Lift', @Detail ='' --7405
exec eAlerts_getAlertDetails @mode='', @Route = 'Boat', @Detail ='' --7827
------------
------------


drop INDEX ix_ServiceAlerts_Mode ON [thetweb].[dbo].[ServiceAlerts]



---- Below indexes trace4
----
--CREATE NONCLUSTERED INDEX ix_ServiceAlerts_Route ON [thetweb].[dbo].[ServiceAlerts] ( [Route] ) ;
-----
exec eAlerts_getAdvisoryDetails @mode='cr', @route='', @Detail = '1' --8200
exec eAlerts_getAdvisoryDetails @mode='subway', @route='Silver Line', @Detail ='' --6888
exec eAlerts_getAdvisoryDetails @mode='Elevator', @route='Escalator', @Detail ='' --6958
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Lift', @Detail ='' --1802
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Boat', @Detail ='' --6949

exec eAlerts_getAlertDetails @mode='cr', @route='', @Detail = '1' --8307
exec eAlerts_getAlertDetails @mode='subway', @route='Silver Line', @Detail ='' --11784
exec eAlerts_getAlertDetails @mode='Elevator', @route='Escalator', @Detail ='' --7463
exec eAlerts_getAlertDetails @mode='', @Route = 'Lift', @Detail ='' --7114
exec eAlerts_getAlertDetails @mode='', @Route = 'Boat', @Detail ='' --11621
------------
------------

drop INDEX ix_ServiceAlerts_Route ON [thetweb].[dbo].[ServiceAlerts]



-----
--Drop all indexes
-----
exec eAlerts_getAdvisoryDetails @mode='cr', @route='', @Detail = '1' --5625
exec eAlerts_getAdvisoryDetails @mode='subway', @route='Silver Line', @Detail ='' --5042
exec eAlerts_getAdvisoryDetails @mode='Elevator', @route='Escalator', @Detail ='' --5002
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Lift', @Detail ='' --1703
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Boat', @Detail ='' --5010

exec eAlerts_getAlertDetails @mode='cr', @route='', @Detail = '1' --5757
exec eAlerts_getAlertDetails @mode='subway', @route='Silver Line', @Detail ='' --11754
exec eAlerts_getAlertDetails @mode='Elevator', @route='Escalator', @Detail ='' --5408
exec eAlerts_getAlertDetails @mode='', @Route = 'Lift', @Detail ='' --5225
exec eAlerts_getAlertDetails @mode='', @Route = 'Boat', @Detail ='' --11729
------------
------------

update statistics servicealerts


-----
-- After update Stats
-----
exec eAlerts_getAdvisoryDetails @mode='cr', @route='', @Detail = '1' --1217
exec eAlerts_getAdvisoryDetails @mode='subway', @route='Silver Line', @Detail ='' --1223
exec eAlerts_getAdvisoryDetails @mode='Elevator', @route='Escalator', @Detail ='' --1989
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Lift', @Detail ='' --1964
exec eAlerts_getAdvisoryDetails @mode='', @Route = 'Boat', @Detail ='' --1981

exec eAlerts_getAlertDetails @mode='cr', @route='', @Detail = '1' --1204
exec eAlerts_getAlertDetails @mode='subway', @route='Silver Line', @Detail ='' --13551
exec eAlerts_getAlertDetails @mode='Elevator', @route='Escalator', @Detail ='' --1292
exec eAlerts_getAlertDetails @mode='', @Route = 'Lift', @Detail ='' --1961
exec eAlerts_getAlertDetails @mode='', @Route = 'Boat', @Detail ='' --10266
------------
------------
