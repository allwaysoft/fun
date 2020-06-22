alter system set db_writer_processes=2 scope=spfile;    -- parameter value here can grow up to the max cpu's on the machine. Restart required.

alter system set sga_max_size=NEW_VALUE scope=spfile; -- Look under Oracle sites in favourates for about this parameter. Restart required.
--SGA Target replaces the shared_pool and other paramters from 9i. The SGA Target takes care of the whole SGA and can grow upto sga_max_size


rollback segments are converted to undo tablspace in 10g and we set it to AUTO




