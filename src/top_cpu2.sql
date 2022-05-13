select top 100
		qp.query_plan,
		st.text,
		ISNULL(st.dbid,CONVERT(SMALLINT,att.value)) as dbid,
		dtb.name as dbname,
		qs.creation_time,
		qs.last_execution_time,
		qs.execution_count,
		qs.total_worker_time,
		qs.last_worker_time,
		qs.min_worker_time,
		qs.max_worker_time,
		qs.plan_generation_num,
		qs.total_physical_reads,
		qs.min_physical_reads,
		qs.max_physical_reads,
		qs.total_logical_reads,
		qs.min_logical_reads,
		qs.max_logical_reads,
		qs.total_logical_writes,
		qs.min_logical_writes,
		qs.max_logical_writes,
		qs.total_elapsed_time,
		qs.min_elapsed_time,
		qs.max_elapsed_time,
		qs.total_rows,
		qs.last_rows,
		qs.min_rows,
		qs.max_rows,
		qs.total_dop,
		qs.last_dop,
		qs.min_dop,
		qs.max_dop,
		ISNULL(st.dbid,CONVERT(SMALLINT,att.value)) AS my_dbid
	FROM sys.dm_exec_query_stats qs
		CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
		CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
		LEFT OUTER JOIN(
			SELECT DISTINCT
				qs.plan_handle,
				att.value
			FROM sys.dm_exec_query_stats qs
			CROSS APPLY sys.dm_exec_plan_attributes(qs.plan_handle) att
			WHERE
				att.attribute='dbid') as att
		ON
			qs.plan_handle = att.plan_handle
		LEFT OUTER JOIN sys.databases as dtb
		on ISNULL(st.dbid,CONVERT(SMALLINT,att.value)) = dtb.database_id

order by
	qs.total_worker_time desc
  
