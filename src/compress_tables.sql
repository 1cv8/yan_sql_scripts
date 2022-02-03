
DECLARE @DBName VARCHAR(300) = '';
DECLARE @TableName varchar(400) = '';

DECLARE @SQLString NVARCHAR(MAX) = '';
DECLARE @Compressed int;

IF OBJECT_ID('tempdb..##ts_compress') IS NOT NULL
	DROP TABLE ##ts_compress;

DECLARE DBCursor CURSOR LOCAL STATIC FORWARD_ONLY READ_ONLY
FOR (
	SELECT * FROM 
    (
		SELECT TOP 100000
			[name]
		FROM sys.databases
		WHERE
			[name] not in ('master','tempdb','model','msdb', 'PerfmonData')
			AND [state_desc] = 'ONLINE'
		ORDER BY
			[name]
	) as dbses
	
);

OPEN DBCursor;
FETCH NEXT FROM DBCursor INTO @DBName;
WHILE @@FETCH_STATUS = 0
    BEGIN
		
		SET @Compressed = 0;

		SET @SQLString =
		'USE [' + @DBName + ']
			SELECT
				SCHEMA_NAME(o.[schema_id]) as schema_name,
				o.[name] as table_name
			INTO ##ts_compress
			FROM [' + @DBName + '].sys.objects as o
			WHERE
				o.object_id IN -- uncompressed tables
				(
					SELECT DISTINCT
						[object_id]
					FROM [' + @DBName + '].sys.partitions WITH(NOLOCK)
					WHERE
						[data_compression] = 0
				)
				AND o.[type] IN (''U'', ''V'') -- user types'

		PRINT @DBName + ':'
		--PRINT @SQLString
		EXEC (@SQLString)

		DECLARE TableCursor CURSOR FOR 
		(
			SELECT
				'[' + @DBName + '].[' + tsc.[schema_name] + '].[' + tsc.[table_name]  + ']' as [table_name]
			FROM ##ts_compress as tsc
		);

		-- Цикл по всем таблицам
		OPEN TableCursor
		FETCH NEXT FROM TableCursor INTO @TableName
		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			
			SET @SQLString = 'ALTER TABLE ' + @TableName + ' REBUILD WITH (DATA_COMPRESSION = PAGE, ONLINE = OFF, MAXDOP = 0);'--, SORT_IN_TEMPDB = ON);'
				+ 'ALTER INDEX ALL ON ' + @TableName + ' REBUILD WITH (DATA_COMPRESSION = PAGE, ONLINE = OFF, MAXDOP = 0);'--, SORT_IN_TEMPDB = ON);'
			
			BEGIN TRAN

			BEGIN TRY
				
				--PRINT @SQLString
				EXEC(@SQLString)
				COMMIT TRAN

			END TRY
			BEGIN CATCH
				ROLLBACK TRAN
				PRINT ('rolback: ' + @TableName);
			END CATCH
			
			--PRINT '   tn:' + @TableName;
			
			SET @Compressed = 1;

			-- Следующий элемент цикла по таблицам
			FETCH NEXT FROM TableCursor INTO @TableName
			
		END

		-- делаем шринк базы — возвращаем свободное место на диск

		IF @Compressed = 1 
		Begin
			print 'shrinking ...'
			SET @SQLString = 'DBCC SHRINKDATABASE('+ @DBName + ', 5)';
			EXEC (@SQLString)
		end;

		CLOSE TableCursor;
		DEALLOCATE TableCursor;

		DROP TABLE ##ts_compress;

		-- Следующий элемент цикла по базам
        FETCH NEXT FROM DBCursor INTO @DBName;
    END

CLOSE DBCursor;
DEALLOCATE DBCursor;
