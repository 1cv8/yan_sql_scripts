
DECLARE @DBName VARCHAR(300) = '';
DECLARE @SQLString NVARCHAR(MAX) = '';

DECLARE DBCursor CURSOR LOCAL STATIC FORWARD_ONLY READ_ONLY
FOR (
	SELECT * FROM 
    (
		SELECT TOP 100000
			[name]
		FROM sys.databases
		WHERE
			[name] not in ('master','tempdb','model','msdb')
			AND [state_desc] = 'ONLINE'
		ORDER BY
			[name]
	) as dbses
	
);

OPEN DBCursor;
FETCH NEXT FROM DBCursor INTO @DBName;
WHILE @@FETCH_STATUS = 0
    BEGIN
		
		PRINT @DBName;

		SET @SQLString =
		'USE [' + @DBName + '];  
			ALTER DATABASE [' + @DBName + '] SET RECOVERY SIMPLE;';
		--PRINT @SQLString;
		EXEC (@SQLString);

		--DBCC SHRINKFILE (ИмяФайлаЛога, 100) -- 100 кол-во мб
		
		SET @SQLString =
		'DBCC SHRINKDATABASE('+ @DBName + ')';

		PRINT @SQLString;
		EXEC (@SQLString);

		-- Следующий элемент цикла по базам
		FETCH NEXT FROM DBCursor INTO @DBName;

    END

CLOSE DBCursor;
DEALLOCATE DBCursor;
