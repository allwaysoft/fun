/* loop over who3 */ 
--Spwho3 is equivalent to who_is_active script available online
DECLARE @OnCallMode bit = 1
DECLARE @destination_table VARCHAR(4000) ;
DECLARE @basetable varchar(2000);
DECLARE @numberOfRuns INT = 25;
DECLARE @tsql varchar(200);
DECLARE @msg NVARCHAR(1000) ;SET @numberOfRuns = 25;--base table schema of default who3
set @basetable = 'CREATE TABLE [sp_who3table](
    [session_id] [smallint] NOT NULL,
    [host_name] [nvarchar](128) NULL,
    [login_name] [nvarchar](128) NOT NULL,
    [dbname] [nvarchar](128) NULL,
    [status] [nvarchar](30) NOT NULL,
    [command] [nvarchar](32) NOT NULL,
    [running_time] [varchar](109) NULL,
    [BlkBy] [smallint] NULL,
    [NoOfOpenTran] [int] NOT NULL,
    [wait_type] [nvarchar](60) NULL,
    [granted_memory_GB] [numeric](10, 2) NULL,
    [object_name] [nvarchar](257) NULL,
    [program_name] [nvarchar](128) NULL,
    [query_plan] [xml] NULL,
    [sql_text] [nvarchar](max) NULL,
    [cpu_time] [int] NOT NULL,
    [start_time] [datetime] NOT NULL,
    [percent_complete] [real] NOT NULL,
    [est_time_to_go] [varchar](109) NULL,
    [est_completion_time] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]';
--give me todays date for custom table
If @OnCallMode = 0 
    BEGIN
        SET @destination_table = '##who3_' +  CONVERT(VARCHAR, GETDATE(), 112);
    END
Else if @OnCallMode = 1 
    BEGIN
        SET @destination_table = '##who3_' + CONVERT(VARCHAR, GETDATE(), 112) + convert(varchar(10),datepart(HOUR,getdate())) + convert(varchar(4),datepart(MINUTE,getdate())) + convert(varchar(4),datepart(SECOND,getdate()));
    END
--replace base table name with new name
SET @basetable = REPLACE(@basetable, '[sp_who3table]', @destination_table);
SET @msg = 'your table is ' + @destination_table;
RAISERROR(@msg,0,0) WITH NOWAIT;
--create new table
exec(@basetable);
WHILE @numberOfRuns > 0
    BEGIN
    SET @tsql = 'INSERT INTO ' + @destination_table + char(13) + 'EXEC master.dbo.sp_who3'
    EXEC(@tsql)
    SET @numberOfRuns = @numberOfRuns - 1 
     IF @numberOfRuns > 0
            BEGIN
                SET @msg = CONVERT(CHAR(19), GETDATE(), 121) + ': ' +
                 'Logging info. Waiting...'
                RAISERROR(@msg,0,0) WITH NOWAIT
                WAITFOR DELAY '00:00:05'
            END
        ELSE
            BEGIN
                SET @msg = CONVERT(CHAR(19), GETDATE(), 121) + ': ' + 'Done.'
                RAISERROR(@msg,0,0) WITH NOWAIT
            END
    END
    print char(13)
    RAISERROR('------------------------------------',0,0) WITH NOWAIT
    set @msg = 'SELECT * FROM ' + @destination_table
    RAISERROR(@msg,0,0) WITH NOWAIT
    set @msg = '--DROP TABLE ' + @destination_table
    RAISERROR(@msg,0,0) WITH NOWAIT
GO