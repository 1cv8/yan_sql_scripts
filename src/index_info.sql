use [dblf]

SELECT Top 500
	i.name + ' ON [' + o.name + '] ' as name,
	s.avg_fragmentation_in_percent as fragm_in_percent,
	s.page_count as page_count,
	(s.page_count*s.avg_fragmentation_in_percent)/100 as page_fragmented

	FROM (
		SELECT 
			  s.[object_id]
			, s.index_id
			, avg_fragmentation_in_percent = MAX(s.avg_fragmentation_in_percent)
			, page_count = MAX(s.page_count)
		FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'sampled') s
		WHERE 
			s.index_id > 0 -- <> HEAP
		AND s.page_count > 100
		--and s.avg_fragmentation_in_percent > 0.1
		--AND s.page_count >= 300000
		--AND (s.avg_fragmentation_in_percent + (s.page_count/128000)) > 10

		GROUP BY
			s.[object_id],
			s.index_id
	) s
	JOIN sys.indexes i WITH(NOLOCK) ON s.[object_id] = i.[object_id] AND s.index_id = i.index_id
	JOIN sys.objects o WITH(NOLOCK) ON o.[object_id] = s.[object_id]
  
order by
	page_fragmented desc
