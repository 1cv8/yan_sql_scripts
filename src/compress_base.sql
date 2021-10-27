
use [some_basename]

EXEC sp_MSforeachtable 'ALTER INDEX ALL ON ? REBUILD WITH (DATA_COMPRESSION = PAGE)'
GO

EXEC sp_MSforeachtable 'ALTER TABLE ? REBUILD WITH (DATA_COMPRESSION = PAGE)'
GO

DECLARE @cmd VARCHAR(4000)

-- делаем шринк базы — возвращаем свободное место на диск
SELECT @cmd=(
  SELECT 'DBCC SHRINKDATABASE('+ DB_NAME() + ')'
)
EXEC (@cmd)
GO
