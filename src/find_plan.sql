
SELECT
	T.[text]
	,T.[creation_time]
	,T.[execution_count]
	,T.[last_execution_time]
	,Т.[max_worker_time]
	,qp.query_plan
FROM
(SELECT
     st.[text]	 
	 ,qs.plan_handle
	 ,MAX(qs.[max_worker_time]) as [max_worker_time]
	 ,MAX(qs.creation_time) AS [creation_time]
	 ,MAX(qs.last_execution_time) AS [last_execution_time]
	 ,SUM(qs.execution_count) AS [execution_count]
FROM
	sys.dm_exec_query_stats qs
	CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
	
WHERE 
    -- Фильтр по дате последнего выполнения для оптимизации
    -- По умолчанию фильтруются запросы за последний час
    qs.last_execution_time > (CURRENT_TIMESTAMP - '04:00:00.000')
	--AND qs.last_execution_time < '20210917 14:21:30'
	--AND qs.last_execution_time > '20210917 14:21:19'
	-- Поиск по частям текста запроса
	AND st.[text] LIKE '%_Document132%'
	AND st.[text] LIKE '%_AccumRg7589%'
	AND st.[text] LIKE '%_AccumRg7692%'
	AND st.[text] LIKE '%_AccumRgT7701%'
	AND st.[text] LIKE '%_AccumRg7786%'
	AND st.[text] LIKE '%_InfoRg10295%'
	AND st.[text] LIKE '%_InfoRg9180%'
	AND st.[text] LIKE '%_Reference37%'
	AND st.[text] LIKE '%_Reference37_VT8438%'
	AND st.[text] LIKE '%_Reference54%'
	AND st.[text] LIKE '%_Reference75%'
	AND st.[text] LIKE '%_Reference75_VT8367%'
	AND st.[text] LIKE '%_Reference94%'
	

GROUP BY
     st.[text]
	 ,qs.plan_handle) T
	CROSS APPLY sys.dm_exec_query_plan(T.plan_handle) qp
--order by
	--T.[last_execution_time]
  
