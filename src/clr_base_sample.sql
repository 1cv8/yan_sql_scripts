USE [some_basename];

DECLARE @DBNAME NVARCHAR(MAX) = '[some_basename]';
DECLARE @SQLString NVARCHAR(MAX);
DECLARE @FIELDS NVARCHAR(MAX);

DECLARE @DateStart NVARCHAR(MAX);
DECLARE @DateStartM3 NVARCHAR(MAX);

SELECT @DateStart = DATEADD(year, 2000, DATEADD(month, -6, SYSDATETIME()));  
SELECT @DateStartM3 = DATEADD(year, 2000, DATEADD(month, -3, SYSDATETIME()));  

-- Справочник.ХранилищеДополнительнойИнформации
IF OBJECT_ID('tempdb..##clr_demo_bases_data') IS NOT NULL
	DROP TABLE ##clr_demo_bases_data;

BEGIN TRAN
BEGIN TRY
	
	-- без [_Version]
	SET @FIELDS = '[_IDRRef],[_Marked],[_PredefinedID],[_Description],[_Fld1146RRef],[_Fld1147],[_Fld1148_TYPE],[_Fld1148_RTRef],[_Fld1148_RRRef],[_Fld1150],[_Fld10334RRef],[_Fld11903],[_Fld21403],[_Fld21839],[_Fld22196],[_Fld22398]';

	SET @SQLString =
		'USE ' + @DBNAME + ';
		SELECT ' + @FIELDS + '
		INTO ##clr_demo_bases_data
		FROM [dbo].[_Reference97]'

	--PRINT @SQLString
	EXEC (@SQLString)

	SET @SQLString =
		'USE ' + @DBNAME + ';
		TRUNCATE TABLE [dbo].[_Reference97];'
	--PRINT @SQLString
	EXEC (@SQLString)

	SET @SQLString =
		'USE ' + @DBNAME + ';
		INSERT INTO [dbo].[_Reference97]
			(' + @FIELDS + ',[_Fld1149])
		SELECT
			' + @FIELDS + '
			,0x01010800000000000000EFBBBF7B2255227D as [_Fld1149]
		FROM ##clr_demo_bases_data
		ORDER BY [_IDRRef];'

	--PRINT @SQLString
	EXEC (@SQLString)

	COMMIT TRAN

END TRY
BEGIN CATCH
	ROLLBACK TRAN
	PRINT 'rolback: Справочник.ХранилищеДополнительнойИнформации';
	PRINT ERROR_MESSAGE();
END CATCH

PRINT 'Справочник.ХранилищеДополнительнойИнформации'
--  <<< Справочник.ХранилищеДополнительнойИнформации

IF OBJECT_ID('tempdb..##clr_demo_bases_data') IS NOT NULL
	DROP TABLE ##clr_demo_bases_data;

-- Справочник.ХранилищеДополнительнойИнформации


--  РегистрНакопления._WMSОстаткиМаркированногоТовара.Итоги
ALTER INDEX _AccumRgT22156_5  ON  dbo._AccumRgT22156  DISABLE;
IF INDEXPROPERTY(OBJECT_ID(@DBNAME + '.[dbo].[_AccumRgT22156]'), 'missing_index_20210507_7649', 'IndexID') IS NOT NULL
	DROP INDEX [missing_index_20210507_7649] ON [dbo].[_AccumRgT22156];


--  РегистрНакопления._WMSОстаткиМаркированногоТовара
ALTER INDEX _AccumRg22148_7  ON  dbo._AccumRg22148  DISABLE;
IF INDEXPROPERTY(OBJECT_ID(@DBNAME + '.[dbo].[_AccumRg22148]'), 'missing_index_20210428_39885', 'IndexID') IS NOT NULL
	DROP INDEX [missing_index_20210428_39885] ON [dbo]._AccumRg22148;
IF INDEXPROPERTY(OBJECT_ID(@DBNAME + '.[dbo].[_AccumRg22148]'), 'missing_index_20210524_311200', 'IndexID') IS NOT NULL
	DROP INDEX [missing_index_20210524_311200] ON [dbo]._AccumRg22148;

PRINT 'РегистрНакопления._WMSОстаткиМаркированногоТовара'


-- РегистрСведений.УС_ОчередьПочта
TRUNCATE TABLE dbo._InfoRg17637;
PRINT 'РегистрСведений.УС_ОчередьПочта'


-- AccumRgT7183
--  РегистрНакопления.ЗаказыПокупателей.Итоги
--    Закрыть старые заказы.


--_AccumRgT22156
--  РегистрНакопления._WMSОстаткиМаркированногоТовара.Итоги
--     пересчитать итоги?


-- _InfoRg11137
--    РегистрСведений._ТендерСтатистика
BEGIN TRAN
BEGIN TRY
	
	SET @FIELDS = '*';

	SET @SQLString =
		'USE ' + @DBNAME + ';
		SELECT ' + @FIELDS + '
		INTO ##clr_demo_bases_data
		FROM [dbo].[_InfoRg11137]
		WHERE
			[_Fld11141] >= ''' + @DateStart + '''' -- ДатаПроведения

	--PRINT @SQLString
	EXEC (@SQLString)

	SET @SQLString =
		'USE ' + @DBNAME + ';
		TRUNCATE TABLE [dbo].[_InfoRg11137];'
	--PRINT @SQLString
	EXEC (@SQLString)

	SET @SQLString =
		'USE ' + @DBNAME + ';
		INSERT INTO [dbo].[_InfoRg11137]
		SELECT
			' + @FIELDS + '
		FROM ##clr_demo_bases_data;'

	--PRINT @SQLString
	EXEC (@SQLString)

	COMMIT TRAN

END TRY
BEGIN CATCH
	ROLLBACK TRAN
	PRINT 'rolback: РегистрСведений._ТендерСтатистика';
	PRINT ERROR_MESSAGE();
END CATCH

PRINT 'РегистрСведений._ТендерСтатистика'


-- РегистрСведений._ОсталосьОтгрузить_Накоплено_ВП_ПЗ
IF OBJECT_ID('tempdb..##clr_demo_bases_data') IS NOT NULL
	DROP TABLE ##clr_demo_bases_data;

BEGIN TRAN
BEGIN TRY
	
	SET @FIELDS = '*';

	SET @SQLString =
		'USE ' + @DBNAME + ';
		SELECT ' + @FIELDS + '
		INTO ##clr_demo_bases_data
		FROM [dbo].[_InfoRg21492]
		WHERE
			[_Period] >= ''' + @DateStartM3 + '''' -- ДатаПроведения

	--PRINT @SQLString
	EXEC (@SQLString)

	SET @SQLString =
		'USE ' + @DBNAME + ';
		TRUNCATE TABLE [dbo].[_InfoRg21492];'
	--PRINT @SQLString
	EXEC (@SQLString)

	SET @SQLString =
		'USE ' + @DBNAME + ';
		INSERT INTO [dbo].[_InfoRg21492]
		SELECT
			' + @FIELDS + '
		FROM ##clr_demo_bases_data;'

	--PRINT @SQLString
	EXEC (@SQLString)

	COMMIT TRAN

END TRY
BEGIN CATCH
	ROLLBACK TRAN
	PRINT 'rolback: РегистрСведений._ОсталосьОтгрузить_Накоплено_ВП_ПЗ';
	PRINT ERROR_MESSAGE();
END CATCH

PRINT 'РегистрСведений._ОсталосьОтгрузить_Накоплено_ВП_ПЗ'

truncate table [dbo].[_DataHistoryQueue0];
truncate table [dbo].[_DataHistoryVersions];

-- РегистрСведений.ус_МаркировкаРезультатыОбмена
IF OBJECT_ID('tempdb..##clr_demo_bases_data') IS NOT NULL
	DROP TABLE ##clr_demo_bases_data;

BEGIN TRAN
BEGIN TRY
	
	SET @FIELDS = '*';

	SET @SQLString =
		'USE ' + @DBNAME + ';
		SELECT ' + @FIELDS + '
		INTO ##clr_demo_bases_data
		FROM [dbo].[_InfoRg22197]
		WHERE
			[_Period] >= ''' + @DateStartM3 + '''' -- ДатаПроведения

	--PRINT @SQLString
	EXEC (@SQLString)

	SET @SQLString =
		'USE ' + @DBNAME + ';
		TRUNCATE TABLE [dbo].[_InfoRg22197];'
	--PRINT @SQLString
	EXEC (@SQLString)

	SET @SQLString =
		'USE ' + @DBNAME + ';
		INSERT INTO [dbo].[_InfoRg22197]
		SELECT
			' + @FIELDS + '
		FROM ##clr_demo_bases_data;'

	--PRINT @SQLString
	EXEC (@SQLString)

	COMMIT TRAN

END TRY
BEGIN CATCH
	ROLLBACK TRAN
	PRINT 'rolback: РегистрСведений.ус_МаркировкаРезультатыОбмена';
	PRINT ERROR_MESSAGE();
END CATCH

PRINT 'РегистрСведений.ус_МаркировкаРезультатыОбмена'

-- РегистрСведений.ус_МаркировкаРезультатыОбмена


IF OBJECT_ID('tempdb..##clr_demo_bases_data') IS NOT NULL
	DROP TABLE ##clr_demo_bases_data;
