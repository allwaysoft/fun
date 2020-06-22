--Monitor log shipping, below can be run on primary of seconday, results will vary when run on primary vs seconday
sp_help_log_shipping_monitor


--Run on Primary
sp_help_log_shipping_monitor_primary @primary_server = 'BOS-DBWH02', @primary_database ='AccountPerformance'


--Run on secondary
sp_help_log_shipping_monitor_secondary @secondary_server = 'EC2AMAZ-BVK102N', @secondary_database ='AccountPerformance'
