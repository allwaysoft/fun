alter system set log_archive_format = 'FNPRDB_%s_%t_%r.ARC' scope=spfile;
alter system set log_archive_dest_1='location=USE_DB_RECOVERY_FILE_DEST' scope=both;
alter system set smtp_out_server='smtprelayhs.mbta.com' scope=both;
alter system set disk_asynch_io=true scope=spfile;
alter system set filesystemio_options=asynch scope=spfile;
alter system set BACKUP_TAPE_IO_SLAVES=true scope=spfile;
alter system set "_enable_minscn_cr"=false scope=spfile;
alter system set "_smu_debug_mode"=134217728 scope=spfile;
alter system set "_unnest_subquery" = false scope=both;
alter system set "_gby_hash_aggregation_enabled"=false scope=both;
alter system set control_management_pack_access = NONE  scope=both;
ALTER DATABASE DEFAULT TEMPORARY TABLESPACE temp;
alter system set session_cached_cursors =100 scope=spfile;
ALTER SYSTEM SET job_queue_processes = 5 scope=both;
alter system set open_cursors = 600 scope=both;
alter system set utl_file_dir = "/usr/tmp" scope=spfile;
alter system set processes = 500 scope=spfile;


