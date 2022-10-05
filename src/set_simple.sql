
DECLARE @DBName VARCHAR(300) = '';
DECLARE @DBID int = 0;

DECLARE @FileName varchar(400) = '';

DECLARE @SQLString NVARCHAR(MAX) = '';

DECLARE DBCursor CURSOR LOCAL STATIC FORWARD_ONLY READ_ONLY
FOR (
	SELECT * FROM 
    (
		SELECT
			[name],
			[database_id]
		FROM sys.databases  
		WHERE
			recovery_model_desc = 'FULL'
			and [name] not in ('master','tempdb','model','msdb')
	) as dbses
	
);

OPEN DBCursor;
FETCH NEXT FROM DBCursor INTO @DBName, @DBID;
WHILE @@FETCH_STATUS = 0
    BEGIN
		
		SET @SQLString = 'ALTER DATABASE ' + @DBName + ' SET RECOVERY SIMPLE;';
		EXEC (@SQLString)
		--Print(@SQLString)

		DECLARE FileCursor CURSOR FOR 
		(
			SELECT
				[name]
			FROM sys.master_files
			WHERE
				database_id = @DBID
				and type = 1
		)
		
		OPEN FileCursor;
		FETCH NEXT FROM FileCursor INTO @FileName;
		WHILE @@FETCH_STATUS = 0
			BEGIN
				
				--Print(@FileName)
				SET @SQLString = 
				'USE ' + @DBName + ';
					DBCC SHRINKFILE (' + @FileName +', 5);'
				EXEC (@SQLString)
				--Print(@SQLString)
				
				-- Следующий элемент цикла по файлам
				FETCH NEXT FROM FileCursor INTO @FileName;
			END
		CLOSE FileCursor;
		DEALLOCATE FileCursor;


		-- Следующий элемент цикла по базам
        FETCH NEXT FROM DBCursor INTO @DBName, @DBID;
    END

CLOSE DBCursor;
DEALLOCATE DBCursor;
