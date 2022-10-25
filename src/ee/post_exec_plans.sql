CREATE EVENT SESSION [PerfStats_LWP_Plan_All] ON SERVER 
ADD EVENT sqlserver.query_post_execution_plan_profile(
    ACTION(sqlos.scheduler_id,sqlserver.database_id,sqlserver.is_system,sqlserver.plan_handle,sqlserver.query_hash_signed,sqlserver.query_plan_hash_signed,sqlserver.server_instance_name,sqlserver.session_id,sqlserver.session_nt_username,sqlserver.sql_text)
    WHERE ([package0].[equal_uint64]([sqlserver].[database_id],(9)) AND [duration]>(1000)))
ADD TARGET package0.event_file(SET filename=N'C:\Temp\PerfStats_LWP_Plan_All.xel',max_file_size=(50),max_rollover_files=(2))
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO
