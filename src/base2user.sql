
DECLARE @DBName as nvarchar(40) = 'db_ch'
DECLARE @UName as nvarchar(40) = 'u_db_ch'

DECLARE @SQLString NVARCHAR(4000)
SET @SQLString = 'USE [' + @DBName + '];
                  IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N''' + @UName + ''')
                    DROP USER [' + @UName + '];
                  CREATE USER [' + @UName + '] FOR LOGIN [' + @UName + '];
				  ALTER USER [' + @UName + '] WITH DEFAULT_SCHEMA=[db_owner];
				  ALTER ROLE [db_owner] ADD MEMBER [' + @UName + ']'
EXEC (@SQLString)
