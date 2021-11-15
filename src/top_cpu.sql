IF OBJECT_ID('tempdb..##cpu_nls_T1') IS NOT NULL
	DROP TABLE ##cpu_nls_T1;

IF OBJECT_ID('tempdb..##cpu_nls_T2') IS NOT NULL
	DROP TABLE ##cpu_nls_T2;

SELECT TOP 1000000
	(qs.max_elapsed_time) as elapsed_time,
	(qs.total_worker_time) as worker_time,
	qp.query_plan,
	st.text,
	dtb.name,
	qs.*,
	st.dbid
INTO ##cpu_nls_T2
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
left outer join sys.databases as dtb
	on st.dbid = dtb.database_id
where
	qs.last_execution_time > (CURRENT_TIMESTAMP - '06:00:00.000')

order by
	qs.last_execution_time desc
;


SELECT
	SUM(max_elapsed_time) as elapsed_time,
	SUM(total_worker_time) as worker_time
into ##cpu_nls_T1
FROM ##cpu_nls_T2


select top 100
	(T2.elapsed_time*100/T1.elapsed_time) as percent_elapsed_time,
	(T2.worker_time*100/T1.worker_time) as percent_worker_time,
	T2.*
from ##cpu_nls_T2 as T2
INNER JOIN ##cpu_nls_T1 as T1
	ON 1=1

--where
--	T2.text like '%dbo._Document9297_VT14378%'

order by
	T2.worker_time desc
;

drop table ##cpu_nls_T2
;

drop table ##cpu_nls_T1
;
