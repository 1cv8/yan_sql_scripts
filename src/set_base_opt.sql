
DECLARE @DBName VARCHAR(300) = '';
DECLARE @DBID int = 0;

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
			[name] not in ('master','tempdb','model','msdb', 'dblf_support')
	) as dbses
	
);

OPEN DBCursor;
FETCH NEXT FROM DBCursor INTO @DBName, @DBID;
WHILE @@FETCH_STATUS = 0
    BEGIN

		SET @SQLString =
			'ALTER DATABASE [' + @DBName + '] SET AUTO_CLOSE OFF WITH NO_WAIT;
			 ALTER DATABASE [' + @DBName + '] SET AUTO_SHRINK OFF WITH NO_WAIT;
			 ALTER DATABASE [' + @DBName + '] SET PAGE_VERIFY CHECKSUM WITH NO_WAIT;
			 ALTER DATABASE [' + @DBName + '] SET AUTO_CREATE_STATISTICS ON WITH NO_WAIT;
			 ALTER DATABASE [' + @DBName + '] SET AUTO_UPDATE_STATISTICS ON WITH NO_WAIT;
			 ALTER DATABASE [' + @DBName + '] SET AUTO_UPDATE_STATISTICS_ASYNC ON WITH NO_WAIT;';
		EXEC (@SQLString)
		--Print(@SQLString)


		-- Следующий элемент цикла по базам
        FETCH NEXT FROM DBCursor INTO @DBName, @DBID;
    END

CLOSE DBCursor;
DEALLOCATE DBCursor;
